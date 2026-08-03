import 'package:flutter/material.dart';
import '../models/market_models.dart';
import '../services/data_service.dart';
import '../widgets/price_chart_card.dart';
import '../widgets/market_average_card.dart';
import '../widgets/session_behavior_card.dart';
import '../widgets/news_events_card.dart';
import '../widgets/signal_engine_card.dart';
import '../widgets/oscillator_card.dart';
import '../widgets/dashboard_card.dart';

/// Everything here uses Expanded/flex instead of fixed heights or
/// SingleChildScrollView. That's deliberate: the whole point is that
/// this fits inside whatever window size it's given, compressing
/// proportionally rather than scrolling or overflowing.
class DashboardScreen extends StatefulWidget {
  final DataService dataService;
  const DashboardScreen({super.key, required this.dataService});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  DashboardSnapshot? _snapshot;

  @override
  void initState() {
    super.initState();
    widget.dataService.watchDashboard().listen((snapshot) {
      if (mounted) setState(() => _snapshot = snapshot);
    });
  }

  @override
  Widget build(BuildContext context) {
    final snap = _snapshot;
    if (snap == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // LEFT COLUMN — chart stack. Flex ratios: price chart gets the
          // most vertical room, market average next, session behavior least.
          Expanded(
            flex: 17,
            child: Column(
              children: [
                if (!snap.isLiveData) const Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Align(alignment: Alignment.centerLeft, child: MockDataBadge()),
                ),
                Expanded(
                  flex: 5,
                  child: PriceChartCard(candles: snap.candles, currentPrice: snap.currentPrice),
                ),
                const SizedBox(height: 12),
                Expanded(
                  flex: 3,
                  child: MarketAverageCard(points: snap.composite),
                ),
                const SizedBox(height: 12),
                Expanded(
                  flex: 2,
                  child: SessionBehaviorCard(sessions: snap.sessions),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // RIGHT COLUMN — news/signal/oscillators.
          Expanded(
            flex: 10,
            child: Column(
              children: [
                Expanded(
                  flex: 4,
                  child: NewsEventsCard(event: snap.nextEvent),
                ),
                const SizedBox(height: 12),
                Expanded(
                  flex: 4,
                  child: SignalEngineCard(state: snap.signalEngine),
                ),
                const SizedBox(height: 12),
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      Expanded(child: OscillatorCard(label: "AO", icon: Icons.show_chart_rounded, bars: snap.ao)),
                      const SizedBox(width: 12),
                      Expanded(child: OscillatorCard(label: "AC", icon: Icons.bar_chart_rounded, bars: snap.ac)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
