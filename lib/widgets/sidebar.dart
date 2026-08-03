import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: const BoxDecoration(
        border: Border(right: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _Logo(),
          const SizedBox(height: 24),
          _NavItem(label: "Dashboard", active: true),
          const _NavItem(label: "News calendar"),
          const _NavItem(label: "Subscriptions"),
          const _NavItem(label: "Trade history"),
          const _NavItem(label: "Reports"),
          const Spacer(),
          const Divider(color: AppColors.border),
          const _NavItem(label: "Settings", icon: Icons.settings_outlined),
        ],
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 64,
          height: 64,
          child: CustomPaint(painter: _FlowerMarkPainter()),
        ),
        const SizedBox(height: 6),
        const Text(
          "NOCTIS",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: 3,
            color: AppColors.black,
          ),
        ),
        const Text(
          "XXIV",
          style: TextStyle(
            fontSize: 12,
            letterSpacing: 4,
            color: AppColors.gray,
          ),
        ),
      ],
    );
  }
}

class _FlowerMarkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final center = Offset(size.width / 2, size.height / 2);
    final r = size.width * 0.16;
    final offsets = [
      Offset(0, -r * 2), Offset(0, r * 2),
      Offset(-r * 2, 0), Offset(r * 2, 0),
      Offset(-r * 1.4, -r * 1.4), Offset(r * 1.4, -r * 1.4),
      Offset(-r * 1.4, r * 1.4), Offset(r * 1.4, r * 1.4),
    ];
    for (final o in offsets) {
      canvas.drawCircle(center + o, r, paint);
    }
    canvas.drawCircle(center, r * 0.4, Paint()..color = AppColors.red);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _NavItem extends StatelessWidget {
  final String label;
  final bool active;
  final IconData? icon;
  const _NavItem({required this.label, this.active = false, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: active ? AppColors.panelTint : null,
        borderRadius: BorderRadius.circular(8),
        border: active
            ? const Border(left: BorderSide(color: AppColors.red, width: 3))
            : null,
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: active ? AppColors.red : AppColors.black),
            const SizedBox(width: 8),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: active ? AppColors.red : AppColors.black,
            ),
          ),
        ],
      ),
    );
  }
}
