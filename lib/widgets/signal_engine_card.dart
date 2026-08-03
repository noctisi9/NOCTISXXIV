import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../models/market_models.dart';
import '../theme/app_theme.dart';
import 'dashboard_card.dart';

class SignalEngineCard extends StatelessWidget {
  final SignalEngineState state;
  const SignalEngineCard({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("SIGNAL ENGINE",
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.black)),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: CustomPaint(
                  painter: _GaugePainter(state.confidencePercent),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("${state.confidencePercent.round()}%",
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                        const Text("BULLISH",
                            style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.red)),
                        const Text("CONFIDENCE", style: TextStyle(fontSize: 7, color: AppColors.gray)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...state.components.map((c) => Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(c.label, style: const TextStyle(fontSize: 11)),
                              Text("${c.percent.round()}%",
                                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        )),
                    const SizedBox(height: 2),
                    Text(
                      "Based on ${state.sampleSize} comparable historical events",
                      style: const TextStyle(fontSize: 9, color: AppColors.gray, fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(child: _ActionButton(label: "BUY ↑", active: state.recommendation == SignalAction.buy, style: _ButtonStyle.buy)),
              const SizedBox(width: 8),
              Expanded(child: _ActionButton(label: "WAIT", active: state.recommendation == SignalAction.wait, style: _ButtonStyle.neutral)),
              const SizedBox(width: 8),
              Expanded(child: _ActionButton(label: "SELL ↓", active: state.recommendation == SignalAction.sell, style: _ButtonStyle.sell)),
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
  final bool active;
  final _ButtonStyle style;
  const _ActionButton({required this.label, required this.active, required this.style});

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
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
        border: active ? null : Border.all(color: AppColors.border),
      ),
      alignment: Alignment.center,
      child: Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: fg)),
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

    canvas.drawCircle(center, radius, Paint()
      ..color = AppColors.border
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8);

    final sweep = 2 * math.pi * (percent / 100);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweep,
      false,
      Paint()
        ..color = AppColors.red
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) => oldDelegate.percent != percent;
}
