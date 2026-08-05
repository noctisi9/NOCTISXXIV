import 'package:flutter/material.dart';
import '../models/market_models.dart';
import '../theme/app_theme.dart';
import 'dashboard_card.dart';

class PriceChartCard extends StatelessWidget {
  final List<Candle> candles;
  final double currentPrice;
  final String selectedTimeframe;
  final ValueChanged<String> onTimeframeChanged;
  final DateTime lastUpdated;
  final bool isLiveData;

  const PriceChartCard({
    super.key,
    required this.candles,
    required this.currentPrice,
    required this.selectedTimeframe,
    required this.onTimeframeChanged,
    required this.lastUpdated,
    required this.isLiveData,
  });

  static const _timeframes = ["M1", "M5", "M15", "H1", "H4", "D1"];

  String _secondsAgo() {
    final diff = DateTime.now().difference(lastUpdated).inSeconds;
    if (diff < 2) return "just now";
    return "${diff}s ago";
  }

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Flexible(
                child: SectionTitle(
                  icon: Icons.candlestick_chart_rounded,
                  redPart: "DOW JONES INDEX (US30)",
                  blackPart: "vs PRICE ACTION",
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: _timeframes.map((tf) {
                  final active = tf == selectedTimeframe;
                  return Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: GestureDetector(
                      onTap: () => onTimeframeChanged(tf),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          border: Border.all(color: active ? AppColors.red : AppColors.border),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(tf,
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: active ? AppColors.red : AppColors.gray)),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // This is the part that proves the data is actually refreshing,
          // rather than sitting still - it counts up every poll cycle.
          Row(
            children: [
              Icon(Icons.circle, size: 7, color: isLiveData ? Colors.green : AppColors.grayLight),
              const SizedBox(width: 4),
              Text(
                isLiveData ? "Live - updated ${_secondsAgo()}" : "Disconnected",
                style: TextStyle(fontSize: 9.5, color: isLiveData ? AppColors.gray : AppColors.red),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(child: CustomPaint(painter: _CandlePainter(candles))),
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: AppColors.red, borderRadius: BorderRadius.circular(4)),
                      child: Text(
                        currentPrice.toStringAsFixed(2),
                        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CandlePainter extends CustomPainter {
  final List<Candle> candles;
  _CandlePainter(this.candles);

  @override
  void paint(Canvas canvas, Size size) {
    if (candles.isEmpty) return;

    final highs = candles.map((c) => c.high);
    final lows = candles.map((c) => c.low);
    final maxP = highs.reduce((a, b) => a > b ? a : b);
    final minP = lows.reduce((a, b) => a < b ? a : b);
    final range = (maxP - minP).clamp(1, double.infinity);

    final gridPaint = Paint()..color = AppColors.border..strokeWidth = 1;
    for (int i = 0; i <= 4; i++) {
      final y = size.height / 4 * i;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final slotWidth = size.width / candles.length;
    final bodyWidth = slotWidth * 0.55;

    double yFor(double price) => size.height - ((price - minP) / range) * size.height;

    for (int i = 0; i < candles.length; i++) {
      final c = candles[i];
      final x = slotWidth * i + slotWidth / 2;
      final isBull = c.isBullish;
      final color = isBull ? Colors.white : AppColors.bearish;
      final strokeColor = isBull ? AppColors.black : AppColors.bearish;

      final wickPaint = Paint()..color = strokeColor..strokeWidth = 1.2;
      canvas.drawLine(Offset(x, yFor(c.high)), Offset(x, yFor(c.low)), wickPaint);

      final bodyTop = yFor([c.open, c.close].reduce((a, b) => a > b ? a : b));
      final bodyBottom = yFor([c.open, c.close].reduce((a, b) => a < b ? a : b));
      final rect = Rect.fromLTRB(x - bodyWidth / 2, bodyTop, x + bodyWidth / 2, bodyBottom.clamp(bodyTop + 1, size.height));

      canvas.drawRect(rect, Paint()..color = color);
      canvas.drawRect(rect, Paint()..color = strokeColor..style = PaintingStyle.stroke..strokeWidth = 1);
    }
  }

  @override
  bool shouldRepaint(covariant _CandlePainter oldDelegate) => oldDelegate.candles != candles;
}
