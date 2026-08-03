import 'package:flutter/material.dart';
import '../models/market_models.dart';
import '../theme/app_theme.dart';
import 'dashboard_card.dart';

/// Renders AO or AC — same widget, different data/icon/label.
/// NOTE: bars here are placeholder-random. Real AO/AC values will come
/// straight from MT5's built-in indicator calculation.
class OscillatorCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final List<OscillatorBar> bars;
  const OscillatorCard({super.key, required this.label, required this.icon, required this.bars});

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 13, color: AppColors.red),
              const SizedBox(width: 5),
              Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.red)),
            ],
          ),
          const SizedBox(height: 4),
          Expanded(child: CustomPaint(painter: _BarPainter(bars), size: Size.infinite)),
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
    final zeroY = size.height / 2;
    final halfHeight = size.height / 2;

    // Zero baseline — makes it visually explicit where "above" vs "below" is.
    canvas.drawLine(
      Offset(0, zeroY),
      Offset(size.width, zeroY),
      Paint()..color = AppColors.border..strokeWidth = 1,
    );

    for (int i = 0; i < bars.length; i++) {
      final b = bars[i];
      final barLength = (b.value / maxV) * halfHeight;
      final x = slot * i + (slot - barWidth) / 2;

      final rect = b.isBullish
          ? Rect.fromLTWH(x, zeroY - barLength, barWidth, barLength) // grows UP from zero
          : Rect.fromLTWH(x, zeroY, barWidth, barLength);            // grows DOWN from zero

      canvas.drawRect(rect, Paint()..color = b.isBullish ? AppColors.black : AppColors.red);
    }
  }

  @override
  bool shouldRepaint(covariant _BarPainter oldDelegate) => oldDelegate.bars != bars;
}
