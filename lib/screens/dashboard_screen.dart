import 'package:flutter/material.dart';
import '../models/market_models.dart';
import '../services/data_service.dart';
import '../theme/app_theme.dart';
import '../widgets/sidebar.dart';
import '../widgets/price_chart_card.dart';
import '../widgets/market_average_card.dart';
import '../widgets/session_behavior_card.dart';
import '../widgets/news_events_card.dart';
import '../widgets/signal_engine_card.dart';
import '../widgets/oscillator_card.dart';
import '../widgets/dashboard_card.dart';

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
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Sidebar(),
          Expanded(
            flex: 17,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!snap.isLiveData) const Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: MockDataBadge(),
                  ),
                  PriceChartCard(candles: snap.candles, currentPrice: snap.currentPrice),
                  MarketAverageCard(points: snap.composite),
                  SessionBehaviorCard(sessions: snap.sessions),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 10,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(0, 20, 20, 20),
              child: Column(
                children: [
                  NewsEventsCard(event: snap.nextEvent),
                  SignalEngineCard(state: snap.signalEngine),
                  OscillatorCard(label: "AO", bars: snap.ao),
                  OscillatorCard(label: "AC", bars: snap.ac),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
