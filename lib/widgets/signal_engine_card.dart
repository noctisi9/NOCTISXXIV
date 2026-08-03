import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../models/market_models.dart';
import '../theme/app_theme.dart';
import 'dashboard_card.dart';

const Map<String, IconData> kScoreIcons = {
  "News Score": Icons.campaign_rounded,
  "Composite Score": Icons.timeline_rounded,
  "Session Score": Icons.schedule_rounded,
  "Trend Score": Icons.trending_up_rounded,
  "Volatility Score": Icons.bolt_rounded,
};

class SignalEngineCard extends StatelessWidget {
  final SignalEngineState state;
  const SignalEngineCard({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SectionTitle(icon: Icons.hub_rounded, redPart: "SIGNAL ENGINE"),
          const SizedBox(height: 8),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: CustomPaint(
                    painter: _GaugePainter(state.confidencePercent),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("${state.confidencePercent.round()}%",
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                          const Text("BULLISH",
                              style: TextStyle(fontSize: 8.5, fontWeight: FontWeight.w700, color: AppColors.red)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...state.components.map((c) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              children: [
                                Icon(kScoreIcons[c.label] ?? Icons.circle, size: 11, color: AppColors.gray),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(c.label,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 10)),
                                ),
                                Text("${c.percent.round()}%",
                                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          )),
                      Text(
                        "Based on ${state.sampleSize} events",
                        style: const TextStyle(fontSize: 8.5, color: AppColors.gray, fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _ActionButton(label: "BUY", icon: Icons.arrow_upward_rounded, active: state.recommendation == SignalAction.buy, style: _ButtonStyle.buy)),
              const SizedBox(width: 6),
              Expanded(child: _ActionButton(label: "WAIT", icon: Icons.pause_rounded, active: state.recommendation == SignalAction.wait, style: _ButtonStyle.neutral)),
              const SizedBox(width: 6),
              Expanded(child: _ActionButton(label: "SELL", icon: Icons.arrow_downward_rounded, active: state.recommendation == SignalAction.sell, style: _ButtonStyle.sell)),
            ],
          ),
        ],
      ),
    );
  }
}

enum _ButtonStyle { buy, neutral, sell }

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool active;
  final _ButtonStyle style;
  const _ActionButton({required this.label, required this.icon, required this.active, required this.style});

  @override
  Widget build(BuildContext context) {
    Color bg = Colors.white;
    Color fg = AppColors.gray;
    if (active) {
      if (style == _ButtonStyle.buy) { bg = AppColors.red; fg = Colors.white; }
      if (style == _ButtonStyle.sell) { bg = AppColors.redDark; fg = Colors.white; }
      if (style == _ButtonStyle.neutral) { bg = AppColors.black; fg = Colors.white; }
    }
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
        border: active ? null : Border.all(color: AppColors.border),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: fg),
          const SizedBox(height: 1),
          Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: fg)),
        ],
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double percent;
  _GaugePainter(this.percent);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 6;

    canvas.drawCircle(center, radius, Paint()..color = AppColors.border..style = PaintingStyle.stroke..strokeWidth = 7);

    final sweep = 2 * math.pi * (percent / 100);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweep,
      false,
      Paint()..color = AppColors.red..style = PaintingStyle.stroke..strokeWidth = 7..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) => oldDelegate.percent != percent;
}
