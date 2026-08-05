import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/market_models.dart';
import 'data_service.dart';

/// Real implementation, backed by the Python FastAPI bridge (mt5_server.py).
///
/// Honesty about what's real vs. not yet built:
/// - candles, currentPrice, ao, ac  -> REAL, live from MT5
/// - composite, sessions, nextEvent, signalEngine -> these engines don't
///   exist yet, so they're returned as explicit NEUTRAL/EMPTY states,
///   never randomly generated.
class Mt5DataService implements DataService {
  final String baseUrl;
  final _controller = StreamController<DashboardSnapshot>.broadcast();
  Timer? _timer;
  String _timeframe = "M1";

  Mt5DataService({this.baseUrl = "http://localhost:8000"}) {
    // 3 second poll - fast enough that the "last updated" clock and the
    // forming candle both visibly move, without hammering the server.
    _timer = Timer.periodic(const Duration(seconds: 3), (_) => _poll());
  }

  @override
  Stream<DashboardSnapshot> watchDashboard() {
    _poll();
    return _controller.stream;
  }

  @override
  Future<DashboardSnapshot> fetchDashboard() async => _fetchSnapshot();

  @override
  void setTimeframe(String timeframe) {
    _timeframe = timeframe;
    _poll(); // refresh immediately on switch, don't wait for next tick
  }

  Future<void> _poll() async {
    try {
      final snapshot = await _fetchSnapshot();
      _controller.add(snapshot);
    } catch (e) {
      _controller.add(_disconnectedSnapshot());
      // ignore: avoid_print
      print("Mt5DataService poll failed: $e");
    }
  }

  Future<DashboardSnapshot> _fetchSnapshot() async {
    final response = await http
        .get(Uri.parse("$baseUrl/api/price-state?timeframe=$_timeframe"))
        .timeout(const Duration(seconds: 8));

    if (response.statusCode != 200) {
      throw Exception("Server returned ${response.statusCode}: ${response.body}");
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    final candles = (data["candles"] as List).map((c) {
      return Candle(
        time: DateTime.fromMillisecondsSinceEpoch((c["time"] as int) * 1000),
        open: (c["open"] as num).toDouble(),
        high: (c["high"] as num).toDouble(),
        low: (c["low"] as num).toDouble(),
        close: (c["close"] as num).toDouble(),
      );
    }).toList();

    final ao = (data["ao"] as List)
        .map((b) => OscillatorBar((b["value"] as num).toDouble(), b["isBullish"] as bool))
        .toList();
    final ac = (data["ac"] as List)
        .map((b) => OscillatorBar((b["value"] as num).toDouble(), b["isBullish"] as bool))
        .toList();

    DateTime fetchedAt;
    try {
      fetchedAt = DateTime.parse(data["fetched_at"] as String).toLocal();
    } catch (_) {
      fetchedAt = DateTime.now();
    }

    return DashboardSnapshot(
      candles: candles,
      currentPrice: (data["current_price"] as num).toDouble(),
      ao: ao,
      ac: ac,
      isLiveData: true,
      lastUpdated: fetchedAt,
      composite: _neutralComposite(candles.length),
      sessions: _neutralSessions(),
      nextEvent: null,
      signalEngine: _neutralSignalEngine(),
    );
  }

  DashboardSnapshot _disconnectedSnapshot() {
    return DashboardSnapshot(
      candles: const [],
      currentPrice: 0,
      ao: const [],
      ac: const [],
      isLiveData: false,
      lastUpdated: DateTime.now(),
      composite: _neutralComposite(0),
      sessions: _neutralSessions(),
      nextEvent: null,
      signalEngine: _neutralSignalEngine(),
    );
  }

  static List<CompositePoint> _neutralComposite(int length) {
    final now = DateTime.now();
    final n = length > 0 ? length : 24;
    return List.generate(
      n,
      (i) => CompositePoint(
        time: now.subtract(Duration(minutes: (n - i) * 5)),
        marketAverage: 0,
        priceReflection: 0,
      ),
    );
  }

  static List<SessionBehavior> _neutralSessions() {
    final flat = List.generate(9, (_) => const SessionPoint(0));
    return [
      SessionBehavior(name: "ASIAN", timeRange: "00:00 - 07:00", points: flat),
      SessionBehavior(name: "LONDON", timeRange: "07:00 - 12:00", points: flat),
      SessionBehavior(name: "NEW YORK", timeRange: "12:00 - 20:00", points: flat),
      SessionBehavior(name: "AFTER HOURS", timeRange: "20:00 - 24:00", points: flat),
    ];
  }

  static SignalEngineState _neutralSignalEngine() {
    return const SignalEngineState(
      confidencePercent: 0,
      recommendation: SignalAction.wait,
      sampleSize: 0,
      components: [
        ScoreComponent("News Score", 0),
        ScoreComponent("Composite Score", 0),
        ScoreComponent("Session Score", 0),
        ScoreComponent("Trend Score", 0),
        ScoreComponent("Volatility Score", 0),
      ],
    );
  }

  void dispose() {
    _timer?.cancel();
    _controller.close();
  }
}
