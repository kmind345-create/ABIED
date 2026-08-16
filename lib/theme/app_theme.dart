import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Palette sampled directly from the portfolio photo:
/// - navy: the scrub uniform
/// - sand: the sandstone hospital building behind him
/// - cream: the sunlit sidewalk
/// - olive: the trees lining the street
/// - sky: the hazy Cairo sky — used as the single glowing accent
class AppColors {
  AppColors._();

  static const Color navy = Color(0xFF0F1526); // deep scrub navy — main bg
  static const Color navyLight = Color(0xFF1B2740); // surface / cards
  static const Color navyLighter = Color(0xFF283656); // hover / borders

  static const Color sand = Color(0xFFC7AD79); // sandstone building
  static const Color sandLight = Color(0xFFE7D9B4);

  static const Color cream = Color(0xFFF4EEE0); // sunlit sidewalk
  static const Color creamDim = Color(0xFFE7DFCB);

  static const Color olive = Color(0xFF5C6B3A); // street trees

  static const Color sky = Color(0xFF8FC7E8); // hazy sky — signature accent
  static const Color skyGlow = Color(0xFFBEE0F5);
}

class AppText {
  AppText._();

  static const String _poppins = 'Poppins';

  static TextStyle display = TextStyle(
    fontFamily: _poppins,
    fontWeight: FontWeight.w600,
    color: AppColors.cream,
    height: 1.15,
    letterSpacing: -0.3,
  );

  static TextStyle body = TextStyle(
    fontFamily: _poppins,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    color: AppColors.cream.withOpacity(0.82),
    height: 1.6,
  );

  static TextStyle mono = GoogleFonts.jetBrainsMono(
    fontWeight: FontWeight.w500,
    color: AppColors.sky,
    letterSpacing: 0.5,
  );
}

/// Simple responsive breakpoints used across the page.
class Breakpoints {
  Breakpoints._();
  static bool isMobile(double w) => w < 760;
  static bool isTablet(double w) => w >= 760 && w < 1080;
  static bool isDesktop(double w) => w >= 1080;
}
