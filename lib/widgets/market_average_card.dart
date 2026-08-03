import 'package:flutter/material.dart';
import '../models/market_models.dart';
import '../theme/app_theme.dart';
import 'dashboard_card.dart';

class MarketAverageCard extends StatelessWidget {
  final List<CompositePoint> points;
  const MarketAverageCard({super.key, required this.points});

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(
            icon: Icons.timeline_rounded,
            redPart: "PRICE REFLECTION",
            blackPart: "vs MARKET AVERAGE",
          ),
          const SizedBox(height: 8),
          Expanded(child: CustomPaint(painter: _DualLinePainter(points), size: Size.infinite)),
        ],
      ),
    );
  }
}

class _DualLinePainter extends CustomPainter {
  final List<CompositePoint> points;
  _DualLinePainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;

    final allValues = [
      ...points.map((p) => p.marketAverage),
      ...points.map((p) => p.priceReflection),
    ];
    final maxV = allValues.reduce((a, b) => a > b ? a : b);
    final minV = allValues.reduce((a, b) => a < b ? a : b);
    final range = (maxV - minV).clamp(0.01, double.infinity);

    double xFor(int i) => size.width * i / (points.length - 1);
    double yFor(double v) => size.height - ((v - minV) / range) * size.height;

    Path buildPath(double Function(CompositePoint) valueOf) {
      final path = Path();
      for (int i = 0; i < points.length; i++) {
        final x = xFor(i);
        final y = yFor(valueOf(points[i]));
        i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
      }
      return path;
    }

    canvas.drawPath(
      buildPath((p) => p.priceReflection),
      Paint()..color = AppColors.black..style = PaintingStyle.stroke..strokeWidth = 2,
    );
    canvas.drawPath(
      buildPath((p) => p.marketAverage),
      Paint()..color = AppColors.red..style = PaintingStyle.stroke..strokeWidth = 2.5,
    );
  }

  @override
  bool shouldRepaint(covariant _DualLinePainter oldDelegate) => oldDelegate.points != points;
}
