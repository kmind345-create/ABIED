import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../data/portfolio_data.dart';
import 'press_scale.dart';

const Map<String, IconData> _sectionIcons = {
  'About': Icons.person_outline,
  'Expertise': Icons.monitor_heart_outlined,
  'Experience': Icons.timeline_outlined,
  'Certifications': Icons.verified_outlined,
  'Contact': Icons.mail_outline,
};

/// The on-phone nav menu — a full drawer with its own staggered
/// entrance, since the desktop top-bar links don't fit a small screen.
class MobileDrawer extends StatelessWidget {
  final Map<String, GlobalKey> sectionKeys;
  final void Function(GlobalKey key) onSelect;

  const MobileDrawer({
    super.key,
    required this.sectionKeys,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final entries = sectionKeys.entries.toList();
    return Drawer(
      backgroundColor: AppColors.navyLight,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 8),
              child: Row(
                children: [
                  Icon(Icons.health_and_safety_outlined, color: AppColors.sky, size: 22),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      PortfolioData.name,
                      style: AppText.display.copyWith(fontSize: 18, fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 300.ms).slideX(begin: -0.15, end: 0),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Divider(color: Colors.white12, height: 28),
            ),
            for (int i = 0; i < entries.length; i++)
              _DrawerItem(
                label: entries[i].key,
                icon: _sectionIcons[entries[i].key] ?? Icons.circle_outlined,
                index: i,
                onTap: () {
                  HapticFeedback.selectionClick();
                  Navigator.of(context).pop();
                  onSelect(entries[i].value);
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final int index;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.label,
    required this.icon,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return PressScale(
      onTap: onTap,
      downScale: 0.97,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(icon, color: AppColors.sky, size: 20),
              const SizedBox(width: 16),
              Text(
                label,
                style: AppText.body.copyWith(fontSize: 16, color: AppColors.cream),
              ),
              const Spacer(),
              Icon(Icons.chevron_right, color: AppColors.sky.withOpacity(0.5), size: 18),
            ],
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(delay: (60 * index).ms, duration: 260.ms)
        .slideX(begin: -0.2, end: 0, curve: Curves.easeOut);
  }
}
