import 'package:flutter/material.dart';
import '../services/data_service.dart';
import '../theme/app_theme.dart';
import '../widgets/sidebar.dart';
import '../widgets/placeholder_page.dart';
import 'dashboard_screen.dart';

/// The app's single top-level navigation container. Sidebar selection
/// changes `_selectedIndex`, and IndexedStack swaps the visible page
/// without rebuilding the others (so DashboardScreen's live data stream
/// doesn't restart every time you click away and back).
class AppShell extends StatefulWidget {
  final DataService dataService;
  const AppShell({super.key, required this.dataService});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;
  bool _settingsOpen = false;

  @override
  Widget build(BuildContext context) {
    final pages = [
      DashboardScreen(dataService: widget.dataService),
      const PlaceholderPage(title: "News Calendar", icon: Icons.calendar_month_rounded),
      const PlaceholderPage(title: "Subscriptions", icon: Icons.workspace_premium_rounded),
      const PlaceholderPage(title: "Trade History", icon: Icons.history_rounded),
      const PlaceholderPage(title: "Reports", icon: Icons.insert_chart_rounded),
    ];

    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Sidebar(
            selectedIndex: _selectedIndex,
            onSelect: (i) => setState(() {
              _selectedIndex = i;
              _settingsOpen = false;
            }),
            onSettingsTap: () => setState(() => _settingsOpen = true),
          ),
          Expanded(
            child: _settingsOpen
                ? const PlaceholderPage(title: "Settings", icon: Icons.settings_rounded)
                : IndexedStack(index: _selectedIndex, children: pages),
          ),
        ],
      ),
    );
  }
}
