import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../data/portfolio_data.dart';
import 'press_scale.dart';
import 'glass_panel.dart';

const Map<String, IconData> _sectionIcons = {
  'About': Icons.person_outline,
  'Expertise': Icons.monitor_heart_outlined,
  'Experience': Icons.timeline_outlined,
  'Certifications': Icons.verified_outlined,
  'Contact': Icons.mail_outline,
};

/// Opens the on-phone nav menu as a centered, glassy card that pops in
/// with a scale + fade animation over a blurred, dimmed backdrop —
/// instead of the usual side drawer.
Future<void> showCenteredMenu(
  BuildContext context, {
  required Map<String, GlobalKey> sectionKeys,
  required void Function(GlobalKey key) onSelect,
}) {
  return showGeneralDialog(
    context: context,
    barrierLabel: 'Menu',
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.55),
    transitionDuration: const Duration(milliseconds: 380),
    pageBuilder: (context, anim1, anim2) {
      return MobileDrawer(sectionKeys: sectionKeys, onSelect: onSelect);
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutBack,
        reverseCurve: Curves.easeIn,
      );
      return BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 6 * animation.value,
          sigmaY: 6 * animation.value,
        ),
        child: FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.85, end: 1.0).animate(curved),
            child: child,
          ),
        ),
      );
    },
  );
}

/// The centered on-phone nav menu card, with its own staggered
/// item entrance.
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
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: GlassPanel(
            borderRadius: const BorderRadius.all(Radius.circular(24)),
            padding: const EdgeInsets.fromLTRB(8, 20, 8, 12),
            gradientColors: [
              AppColors.navyLight.withOpacity(0.92),
              AppColors.navy.withOpacity(0.95),
            ],
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 8, 8),
                  child: Row(
                    children: [
                      Icon(Icons.health_and_safety_outlined, color: AppColors.sky, size: 22),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          PortfolioData.name,
                          style: AppText.display.copyWith(fontSize: 17, fontWeight: FontWeight.w600),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      PressScale(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.06),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.close_rounded, color: AppColors.cream.withOpacity(0.8), size: 18),
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Divider(color: Colors.white12, height: 20),
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
                const SizedBox(height: 8),
              ],
            ),
          ),
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
