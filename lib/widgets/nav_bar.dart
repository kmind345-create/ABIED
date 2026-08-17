import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import '../data/portfolio_data.dart';
import 'mobile_drawer.dart';
import 'press_scale.dart';

class NavBar extends StatelessWidget implements PreferredSizeWidget {
  final Map<String, GlobalKey> sectionKeys;
  const NavBar({super.key, required this.sectionKeys});

  void _scrollTo(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.navy.withOpacity(0.92),
      elevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 80,
      title: Row(
        children: [
          Icon(Icons.health_and_safety_outlined, color: AppColors.sky, size: 20),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              PortfolioData.name,
              overflow: TextOverflow.ellipsis,
              style: AppText.display.copyWith(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
      actions: [
        for (final entry in sectionKeys.entries)
          TextButton(
            onPressed: () => _scrollTo(entry.value),
            child: Text(
              entry.key,
              style: AppText.body.copyWith(fontSize: 14.5, color: AppColors.cream),
            ),
          ),
        const SizedBox(width: 32),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64);
}

/// The compact, floating on-phone nav — an initials chip and a menu
/// button sharing a single pill, hovering over the hero instead of
/// spanning a full-width bar.
class FloatingNavPill extends StatelessWidget {
  final Map<String, GlobalKey> sectionKeys;
  const FloatingNavPill({super.key, required this.sectionKeys});

  void _scrollTo(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.navy.withOpacity(0.55),
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 34,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              PortfolioData.navShortName,
              overflow: TextOverflow.ellipsis,
              style: AppText.mono.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.sand,
              ),
            ),
          ),
          const SizedBox(width: 4),
          PressScale(
            onTap: () {
              HapticFeedback.lightImpact();
              showCenteredMenu(
                context,
                sectionKeys: sectionKeys,
                onSelect: _scrollTo,
              );
            },
            child: Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              child: Icon(Icons.menu_rounded, color: AppColors.cream, size: 22),
            ),
          ),
        ],
      ),
    );
  }
}
