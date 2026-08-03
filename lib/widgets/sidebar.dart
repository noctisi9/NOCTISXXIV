import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class NavPage {
  final String label;
  final IconData icon;
  const NavPage(this.label, this.icon);
}

const List<NavPage> kNavPages = [
  NavPage("Dashboard", Icons.dashboard_rounded),
  NavPage("News calendar", Icons.calendar_month_rounded),
  NavPage("Subscriptions", Icons.workspace_premium_rounded),
  NavPage("Trade history", Icons.history_rounded),
  NavPage("Reports", Icons.insert_chart_rounded),
];

class Sidebar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final VoidCallback onSettingsTap;

  const Sidebar({
    super.key,
    required this.selectedIndex,
    required this.onSelect,
    required this.onSettingsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 14),
      decoration: const BoxDecoration(
        border: Border(right: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _Logo(),
          const SizedBox(height: 20),
          for (int i = 0; i < kNavPages.length; i++)
            _NavItem(
              label: kNavPages[i].label,
              icon: kNavPages[i].icon,
              active: selectedIndex == i,
              onTap: () => onSelect(i),
            ),
          const Spacer(),
          const Divider(color: AppColors.border),
          _NavItem(
            label: "Settings",
            icon: Icons.settings_rounded,
            active: false,
            onTap: onSettingsTap,
          ),
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
        SizedBox(width: 48, height: 48, child: CustomPaint(painter: _FlowerMarkPainter())),
        const SizedBox(height: 4),
        const Text("NOCTIS",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, letterSpacing: 2.5, color: AppColors.black)),
        const Text("XXIV",
            style: TextStyle(fontSize: 10, letterSpacing: 3, color: AppColors.gray)),
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
  final IconData icon;
  final bool active;
  final VoidCallback onTap;
  const _NavItem({required this.label, required this.icon, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        margin: const EdgeInsets.only(bottom: 4),
        padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 10),
        decoration: BoxDecoration(
          color: active ? AppColors.panelTint : null,
          borderRadius: BorderRadius.circular(8),
          border: active ? const Border(left: BorderSide(color: AppColors.red, width: 3)) : null,
        ),
        child: Row(
          children: [
            Icon(icon, size: 17, color: active ? AppColors.red : AppColors.gray),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: active ? AppColors.red : AppColors.black,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
