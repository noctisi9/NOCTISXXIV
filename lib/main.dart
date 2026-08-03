import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'services/data_service.dart';
import 'screens/dashboard_screen.dart';

void main() {
  runApp(const NoctisApp());
}

class NoctisApp extends StatelessWidget {
  const NoctisApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ─────────────────────────────────────────────────────────
    // SWAP POINT: this is the only line that changes when the
    // MT5 bridge is ready. Replace MockDataService() with
    // Mt5DataService(baseUrl: 'http://localhost:8000') once the
    // Python bridge's API (Research 003 §10) is live.
    // ─────────────────────────────────────────────────────────
    final DataService dataService = MockDataService();

    return MaterialApp(
      title: 'NOCTIS XXIV',
      theme: noctisTheme,
      debugShowCheckedModeBanner: false,
      home: DashboardScreen(dataService: dataService),
    );
  }
}
