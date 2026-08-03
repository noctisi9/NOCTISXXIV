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
        children: [
          const Text("NEWS EVENTS",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.red)),
          const SizedBox(height: 12),
          if (event == null)
            const Text("No high-impact event scheduled", style: TextStyle(color: AppColors.gray, fontSize: 12))
          else ...[
            Row(
              children: [
                CircleAvatar(radius: 12, backgroundColor: AppColors.border, child: Text(event!.countryCode, style: const TextStyle(fontSize: 9))),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(event!.name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                      Text("${event!.importance} Impact",
                          style: const TextStyle(fontSize: 11, color: AppColors.red, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "${event!.scheduledTime.hour.toString().padLeft(2, '0')}:${event!.scheduledTime.minute.toString().padLeft(2, '0')}",
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                    ),
                    Text(_fmtCountdown(event!.countdown),
                        style: const TextStyle(fontSize: 10, color: AppColors.red)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _Stat(label: "PREVIOUS", value: event!.previous, color: AppColors.bullish),
                _Stat(label: "FORECAST", value: event!.forecast, color: AppColors.black),
                _Stat(label: "ACTUAL", value: event!.actual ?? "---", color: AppColors.grayLight),
              ],
            ),
            const SizedBox(height: 14),
            const Text("SIGNAL", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Container(
              height: 40,
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
  final String label, value;
  final Color color;
  const _Stat({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 9, color: AppColors.gray, letterSpacing: 0.5)),
        const SizedBox(height: 2),
        Text(value, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: color)),
      ],
    );
  }
}
