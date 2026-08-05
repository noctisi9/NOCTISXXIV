import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'services/data_service.dart';
import 'services/mt5_data_service.dart';
import 'screens/app_shell.dart';

void main() {
  runApp(const NoctisApp());
}

class NoctisApp extends StatelessWidget {
  const NoctisApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ─────────────────────────────────────────────────────────
    // Real MT5 data. Requires mt5_server.py running locally
    // (uvicorn mt5_server:app --port 8000) with MT5 terminal open.
    // ─────────────────────────────────────────────────────────
    final DataService dataService = Mt5DataService();

    return MaterialApp(
      title: 'NOCTIS XXIV',
      theme: noctisTheme,
      debugShowCheckedModeBanner: false,
      home: AppShell(dataService: dataService),
    );
  }
}
