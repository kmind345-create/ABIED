import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';

/// A small "live monitor" style tag — reads like a hospital ID badge
/// that never clocks out: a soft-pulsing status dot (as if a vitals
/// monitor is still live) next to "ICU NURSE". Meant to sit clipped
/// onto the corner of the profile photo.
class IcuBadge extends StatelessWidget {
  const IcuBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.sky.withOpacity(0.45), width: 1.4),
        boxShadow: [
          BoxShadow(
            color: AppColors.sky.withOpacity(0.25),
            blurRadius: 18,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.monitor_heart_rounded, color: AppColors.sky, size: 15),
          const SizedBox(width: 6),
          Text(
            'ICU NURSE',
            style: AppText.mono.copyWith(
              fontSize: 11.5,
              letterSpacing: 1.2,
              color: AppColors.cream,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
