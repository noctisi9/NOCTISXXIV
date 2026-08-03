import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Used for any nav destination that isn't built yet. Keeps navigation
/// fully wired end-to-end now, so adding a real page later is just
/// swapping this out for the real screen in app_shell.dart.
class PlaceholderPage extends StatelessWidget {
  final String title;
  final IconData icon;
  const PlaceholderPage({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 48, color: AppColors.border),
          const SizedBox(height: 12),
          Text(title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.gray)),
          const SizedBox(height: 4),
          const Text("Not built yet", style: TextStyle(fontSize: 12, color: AppColors.grayLight)),
        ],
      ),
    );
  }
}
