import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import 'press_scale.dart';

/// Opens the on-phone nav menu as a plain full-width sheet that rises
/// from the bottom, rounded only at the top — a simple stacked list
/// of section names, no icons, no chevrons, no card border.
Future<void> showCenteredMenu(
  BuildContext context, {
  required Map<String, GlobalKey> sectionKeys,
  required void Function(GlobalKey key) onSelect,
}) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withOpacity(0.6),
    isScrollControlled: true,
    builder: (context) {
      return MobileDrawer(sectionKeys: sectionKeys, onSelect: onSelect);
    },
  );
}

/// The plain, full-width on-phone nav menu.
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
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(
          24,
          14,
          24,
          24 + MediaQuery.of(context).padding.bottom,
        ),
        decoration: BoxDecoration(
          color: AppColors.navyLight.withOpacity(0.98),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 28),
            for (int i = 0; i < entries.length; i++)
              _DrawerItem(
                label: entries[i].key,
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
  final int index;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.label,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return PressScale(
      onTap: onTap,
      downScale: 0.96,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: AppText.display.copyWith(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.cream,
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(delay: (60 * index).ms, duration: 260.ms)
        .slideY(begin: 0.25, end: 0, curve: Curves.easeOut);
  }
}
