import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Every panel on the dashboard uses this shell — keeps padding, border,
/// and corner radius consistent without repeating decoration code.
class DashboardCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const DashboardCard({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.panel,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: child,
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String redPart;
  final String blackPart;
  const SectionTitle({super.key, required this.redPart, this.blackPart = ""});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
        children: [
          TextSpan(text: redPart, style: const TextStyle(color: AppColors.red)),
          if (blackPart.isNotEmpty)
            TextSpan(text: " $blackPart", style: const TextStyle(color: AppColors.black)),
        ],
      ),
    );
  }
}

/// Small badge shown whenever data is coming from MockDataService —
/// makes it impossible to mistake placeholder data for a real feed.
class MockDataBadge extends StatelessWidget {
  const MockDataBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.15),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.amber),
      ),
      child: const Text(
        "MOCK DATA",
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.brown),
      ),
    );
  }
}
