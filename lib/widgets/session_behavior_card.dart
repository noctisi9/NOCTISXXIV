import 'package:flutter/material.dart';
import '../models/market_models.dart';
import '../theme/app_theme.dart';
import 'dashboard_card.dart';

class SessionBehaviorCard extends StatelessWidget {
  final List<SessionBehavior> sessions;
  const SessionBehaviorCard({super.key, required this.sessions});

  static const _colors = [AppColors.asian, AppColors.bullish, AppColors.bearish, AppColors.afterHours];
  static const _tints = [Color(0xFFEAF1FB), Color(0xFFEAF6EC), Color(0xFFFBEAEA), Color(0xFFFDF2E6)];

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(icon: Icons.schedule_rounded, redPart: "SESSION", blackPart: "BEHAVIOR"),
          const SizedBox(height: 8),
          Expanded(
            child: Row(
              children: List.generate(sessions.length, (i) {
                return Expanded(
                  child: Container(
                    margin: EdgeInsets.only(right: i < sessions.length - 1 ? 2 : 0),
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                    decoration: BoxDecoration(color: _tints[i % _tints.length]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(sessions[i].name,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 10.5, fontWeight: FontWeight.w700, color: _colors[i % _colors.length])),
                        Text(sessions[i].timeRange,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 9, color: AppColors.gray)),
                        const SizedBox(height: 4),
                        Expanded(
                          child: CustomPaint(
                            painter: _SparklinePainter(sessions[i].points, _colors[i % _colors.length]),
                            size: Size.infinite,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  final List<SessionPoint> points;
  final Color color;
  _SparklinePainter(this.points, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;
    final values = points.map((p) => p.value);
    final maxV = values.reduce((a, b) => a > b ? a : b);
    final minV = values.reduce((a, b) => a < b ? a : b);
    final range = (maxV - minV).clamp(0.01, double.infinity);

    final path = Path();
    for (int i = 0; i < points.length; i++) {
      final x = size.width * i / (points.length - 1);
      final y = size.height - ((points[i].value - minV) / range) * size.height;
      i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
    }
    canvas.drawPath(path, Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = 1.4);
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter oldDelegate) => oldDelegate.points != points;
}
