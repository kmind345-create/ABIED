import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import '../data/portfolio_data.dart';

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
    final width = MediaQuery.of(context).size.width;
    final isMobile = Breakpoints.isMobile(width);

    return AppBar(
      backgroundColor: AppColors.navy.withOpacity(0.92),
      elevation: 0,
      titleSpacing: isMobile ? 16 : 80,
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
      actions: isMobile
          ? [
              Builder(
                builder: (context) => IconButton(
                  icon: Icon(Icons.menu_rounded, color: AppColors.cream),
                  splashRadius: 22,
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    Scaffold.of(context).openEndDrawer();
                  },
                ),
              ),
              const SizedBox(width: 4),
            ]
          : [
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
