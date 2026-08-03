import 'package:flutter/material.dart';
import '../models/market_models.dart';
import '../theme/app_theme.dart';
import 'dashboard_card.dart';

/// Renders AO or AC — same widget, different data and label.
/// NOTE: bars here are placeholder-random. Real AO/AC values will come
/// straight from MT5's built-in indicator calculation (Research 003 §—
/// "read from MT5, don't recalculate ourselves").
class OscillatorCard extends StatelessWidget {
  final String label;
  final List<OscillatorBar> bars;
  const OscillatorCard({super.key, required this.label, required this.bars});

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.red)),
          const SizedBox(height: 8),
          SizedBox(
            height: 50,
            child: CustomPaint(
              size: const Size(double.infinity, 50),
              painter: _BarPainter(bars),
            ),
          ),
        ],
      ),
    );
  }
}

class _BarPainter extends CustomPainter {
  final List<OscillatorBar> bars;
  _BarPainter(this.bars);

  @override
  void paint(Canvas canvas, Size size) {
    if (bars.isEmpty) return;
    final maxV = bars.map((b) => b.value).reduce((a, b) => a > b ? a : b).clamp(1, double.infinity);
    final slot = size.width / bars.length;
    final barWidth = slot * 0.6;

    for (int i = 0; i < bars.length; i++) {
      final b = bars[i];
      final h = (b.value / maxV) * size.height;
      final x = slot * i + (slot - barWidth) / 2;
      final rect = Rect.fromLTWH(x, size.height - h, barWidth, h);
      canvas.drawRect(rect, Paint()..color = b.isBullish ? AppColors.black : AppColors.red);
    }
  }

  @override
  bool shouldRepaint(covariant _BarPainter oldDelegate) => oldDelegate.bars != bars;
}
