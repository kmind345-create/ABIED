import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../data/portfolio_data.dart';
import 'ecg_line.dart';
import 'floating_icons.dart';
import 'tilt_3d.dart';

class HeroSection extends StatefulWidget {
  final ScrollController scrollController;
  const HeroSection({super.key, required this.scrollController});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> {
  double _scrollProgress = 0;

  // How many pixels of scrolling it takes for the hero to fully
  // fade/slide away — keeps the effect tied to the hero's own height
  // rather than a fixed magic number.
  static const double _fadeDistance = 420;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    if (!widget.scrollController.hasClients) return;
    final offset = widget.scrollController.offset.clamp(0, _fadeDistance);
    final progress = offset / _fadeDistance;
    if (progress != _scrollProgress) {
      setState(() => _scrollProgress = progress.toDouble());
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = Breakpoints.isMobile(width);
    final photoSize = isMobile ? 280.0 : 320.0;

    final circlePhoto = Container(
      width: photoSize,
      height: photoSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.sky.withOpacity(0.55), width: 3.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.sky.withOpacity(0.35),
            blurRadius: 80,
            spreadRadius: 6,
          ),
        ],
        image: const DecorationImage(
          image: AssetImage('assets/images/profile.png'),
          fit: BoxFit.cover,
        ),
      ),
    )
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .custom(
          duration: 2600.ms,
          curve: Curves.easeInOut,
          builder: (context, value, child) => Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.sky.withOpacity(0.18 + value * 0.16),
                  blurRadius: 60 + value * 30,
                  spreadRadius: value * 6,
                ),
              ],
            ),
            child: child,
          ),
        );

    final photoWithBadge = RepaintBoundary(
      child: circlePhoto,
    );

    // The hero visual is just the photo on its own — no glass frame,
    // no corner badges, no shine sweep — but with its 3D tilt back.
    final glassVisual = Tilt3D(
      maxTiltDeg: 7,
      ambientAmplitude: 0.3,
      child: photoWithBadge,
    )
        .animate()
        .fadeIn(duration: 700.ms, delay: 200.ms)
        .scale(begin: const Offset(0.9, 0.9), curve: Curves.easeOutBack);

    final textCol = Column(
      crossAxisAlignment:
          isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Text(
          'ICU NURSE',
          style: AppText.mono.copyWith(fontSize: 13.5, letterSpacing: 3),
        ).animate().fadeIn(delay: 150.ms).slideY(begin: 0.3, end: 0),
        const SizedBox(height: 14),
        Text(
          PortfolioData.name,
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
          style: AppText.display.copyWith(
            fontSize: isMobile ? 40 : 80,
          ),
        ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.3, end: 0),
        const SizedBox(height: 6),
        Text(
          PortfolioData.title,
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
          style: AppText.display.copyWith(
            fontSize: isMobile ? 26 : 34,
            color: AppColors.sky,
            fontWeight: FontWeight.w500,
          ),
        ).animate().fadeIn(delay: 420.ms).slideY(begin: 0.3, end: 0),
        const SizedBox(height: 4),
        Text(
          PortfolioData.subtitle,
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
          style: AppText.body.copyWith(color: AppColors.sand, fontSize: 18),
        ).animate().fadeIn(delay: 520.ms),
        const SizedBox(height: 20),
        SizedBox(
          width: isMobile ? double.infinity : 460,
          child: Text(
            PortfolioData.tagline,
            textAlign: isMobile ? TextAlign.center : TextAlign.left,
            style: AppText.body.copyWith(fontSize: 18),
          ),
        ).animate().fadeIn(delay: 620.ms),
      ],
    );

    final content = isMobile
        ? Column(children: [glassVisual, const SizedBox(height: 48), textCol])
        : Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(flex: 6, child: textCol),
              const SizedBox(width: 48),
              Expanded(flex: 5, child: Center(child: glassVisual)),
            ],
          );

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        left: isMobile ? 24 : 80,
        right: isMobile ? 24 : 80,
        top: isMobile ? 110 : 100,
        bottom: isMobile ? 60 : 100,
      ),
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0.7, -0.6),
          radius: 1.4,
          colors: [AppColors.navyLight, AppColors.navy],
        ),
      ),
      child: Stack(
        children: [
          const Positioned.fill(child: RepaintBoundary(child: FloatingIcons())),
          Transform.translate(
            offset: Offset(0, _scrollProgress * 70),
            child: Opacity(
              opacity: 1 - (_scrollProgress * 0.85),
              child: Column(
                children: [
                  content,
                  const SizedBox(height: 56),
                  const EcgLine(height: 50)
                      .animate()
                      .fadeIn(delay: 800.ms, duration: 800.ms),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
