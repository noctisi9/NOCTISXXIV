import 'dart:async';
import 'dart:math';
import '../models/market_models.dart';

/// Every widget in the dashboard reads through this interface — never
/// directly from mock data or MT5. This is the single swap point.
///
/// When the MT5 bridge is ready, create `Mt5DataService implements DataService`
/// and change ONE line in main.dart. Nothing in the UI layer changes.
abstract class DataService {
  /// Emits a new snapshot whenever underlying data changes.
  Stream<DashboardSnapshot> watchDashboard();

  /// One-off fetch, useful for manual refresh.
  Future<DashboardSnapshot> fetchDashboard();
}

/// ─────────────────────────────────────────────────────────────
/// PLACEHOLDER IMPLEMENTATION
/// Generates plausible-looking fake data so the UI can be built and
/// validated before the MT5 bridge exists. isLiveData is always false
/// here — the UI uses that flag to show a "MOCK DATA" badge, so it's
/// never ambiguous whether you're looking at something real.
/// ─────────────────────────────────────────────────────────────
class MockDataService implements DataService {
  final _controller = StreamController<DashboardSnapshot>.broadcast();
  final _rand = Random();
  Timer? _timer;

  MockDataService() {
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      _controller.add(_generateSnapshot());
    });
  }

  @override
  Stream<DashboardSnapshot> watchDashboard() {
    // emit one immediately so the UI isn't blank on first frame
    Future.microtask(() => _controller.add(_generateSnapshot()));
    return _controller.stream;
  }

  @override
  Future<DashboardSnapshot> fetchDashboard() async => _generateSnapshot();

  void dispose() {
    _timer?.cancel();
    _controller.close();
  }

  DashboardSnapshot _generateSnapshot() {
    return DashboardSnapshot(
      candles: _mockCandles(),
      composite: _mockComposite(),
      sessions: _mockSessions(),
      nextEvent: _mockNewsEvent(),
      signalEngine: _mockSignalEngine(),
      ao: _mockOscillator(),
      ac: _mockOscillator(),
      currentPrice: 41156.40 + _rand.nextDouble() * 40 - 20,
      isLiveData: false, // ← flip meaning: real service always sets this true
    );
  }

  List<Candle> _mockCandles() {
    final now = DateTime.now();
    double price = 41000;
    return List.generate(30, (i) {
      final open = price;
      final change = (_rand.nextDouble() - 0.45) * 40;
      final close = open + change;
      final high = max(open, close) + _rand.nextDouble() * 15;
      final low = min(open, close) - _rand.nextDouble() * 15;
      price = close;
      return Candle(
        time: now.subtract(Duration(minutes: (30 - i) * 5)),
        open: open,
        high: high,
        low: low,
        close: close,
      );
    });
  }

  List<CompositePoint> _mockComposite() {
    final now = DateTime.now();
    double marketAvg = 0, reflection = 0;
    return List.generate(24, (i) {
      marketAvg += (_rand.nextDouble() - 0.42) * 0.3;
      reflection += (_rand.nextDouble() - 0.45) * 0.25;
      return CompositePoint(
        time: now.subtract(Duration(minutes: (24 - i) * 5)),
        marketAverage: marketAvg,
        priceReflection: reflection,
      );
    });
  }

  List<SessionBehavior> _mockSessions() {
    SessionPoint pt(double v) => SessionPoint(v);
    List<SessionPoint> curve(bool up) => List.generate(
        9, (i) => pt(up ? i * 1.2 + _rand.nextDouble() : -i * 0.8 + _rand.nextDouble()));

    return [
      SessionBehavior(name: "ASIAN", timeRange: "00:00 – 07:00", points: curve(true)),
      SessionBehavior(name: "LONDON", timeRange: "07:00 – 12:00", points: curve(true)),
      SessionBehavior(name: "NEW YORK", timeRange: "12:00 – 20:00", points: curve(false)),
      SessionBehavior(name: "AFTER HOURS", timeRange: "20:00 – 24:00", points: curve(true)),
    ];
  }

  NewsEvent _mockNewsEvent() {
    return NewsEvent(
      name: "NFP – NON FARM PAYROLLS",
      countryCode: "US",
      importance: "High",
      scheduledTime: DateTime.now().add(const Duration(minutes: 27, seconds: 42)),
      previous: "+175K",
      forecast: "+185K",
      actual: null,
      countdown: const Duration(minutes: 27, seconds: 42),
    );
  }

  SignalEngineState _mockSignalEngine() {
    return const SignalEngineState(
      confidencePercent: 82,
      recommendation: SignalAction.wait,
      sampleSize: 48, // per Research 003 — always show the evidence count, never a bare %
      components: [
        ScoreComponent("News Score", 85),
        ScoreComponent("Composite Score", 78),
        ScoreComponent("Session Score", 72),
        ScoreComponent("Trend Score", 89),
        ScoreComponent("Volatility Score", 76),
      ],
    );
  }

  List<OscillatorBar> _mockOscillator() {
    return List.generate(16, (i) {
      final v = (_rand.nextDouble() - 0.4) * 30;
      return OscillatorBar(v.abs(), v >= 0);
    });
  }
}

/// ─────────────────────────────────────────────────────────────
/// FUTURE: real implementation
/// ─────────────────────────────────────────────────────────────
/// class Mt5DataService implements DataService {
///   // Connects to the Python MT5 bridge (mt5_bridge.py) via its exposed
///   // API (/market-state, /news-events, /event-reaction, /intelligence
///   // from Research 003 §10) and maps responses onto these same models.
///   // isLiveData is always true here.
/// }
