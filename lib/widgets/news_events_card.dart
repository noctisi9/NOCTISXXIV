import 'package:flutter/material.dart';
import '../models/market_models.dart';
import '../theme/app_theme.dart';
import 'dashboard_card.dart';

class NewsEventsCard extends StatelessWidget {
  final NewsEvent? event;
  const NewsEventsCard({super.key, required this.event});

  String _fmtCountdown(Duration? d) {
    if (d == null) return "—";
    final m = d.inMinutes;
    final s = d.inSeconds % 60;
    return "${m}m ${s}s";
  }

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SectionTitle(icon: Icons.campaign_rounded, redPart: "NEWS EVENTS"),
          const SizedBox(height: 10),
          if (event == null)
            const Expanded(
              child: Center(
                child: Text("No high-impact event scheduled",
                    style: TextStyle(color: AppColors.gray, fontSize: 11)),
              ),
            )
          else ...[
            Row(
              children: [
                Icon(Icons.flag_rounded, size: 20, color: AppColors.gray),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(event!.name,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700)),
                      Row(
                        children: [
                          const Icon(Icons.priority_high_rounded, size: 12, color: AppColors.red),
                          Text("${event!.importance} Impact",
                              style: const TextStyle(fontSize: 10.5, color: AppColors.red, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "${event!.scheduledTime.hour.toString().padLeft(2, '0')}:${event!.scheduledTime.minute.toString().padLeft(2, '0')}",
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                    ),
                    Text(_fmtCountdown(event!.countdown),
                        style: const TextStyle(fontSize: 9.5, color: AppColors.red)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _Stat(icon: Icons.history_rounded, label: "PREVIOUS", value: event!.previous, color: AppColors.bullish),
                _Stat(icon: Icons.trending_flat_rounded, label: "FORECAST", value: event!.forecast, color: AppColors.black),
                _Stat(icon: Icons.check_circle_outline_rounded, label: "ACTUAL", value: event!.actual ?? "---", color: AppColors.grayLight),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: const [
                Icon(Icons.bolt_rounded, size: 13, color: AppColors.black),
                SizedBox(width: 4),
                Text("SIGNAL", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: 4),
            Container(
              height: 32,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.red),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final IconData icon;
  final String label, value;
  final Color color;
  const _Stat({required this.icon, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 10, color: AppColors.gray),
            const SizedBox(width: 3),
            Text(label, style: const TextStyle(fontSize: 8.5, color: AppColors.gray, letterSpacing: 0.4)),
          ],
        ),
        const SizedBox(height: 2),
        Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: color)),
      ],
    );
  }
}
