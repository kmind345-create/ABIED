import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class _OrbSpec {
  final double dx; // -1..1 horizontal position (fraction of width)
  final double dyStart; // starting vertical position in "loop units" (0..1)
  final double size;
  final double parallaxFactor; // how much slower than scroll it moves
  final Color color;
  final double opacity;
  const _OrbSpec({
    required this.dx,
    required this.dyStart,
    required this.size,
    required this.parallaxFactor,
    required this.color,
    required this.opacity,
  });
}

/// A quiet, continuous layer of soft glowing orbs that sits behind the
/// entire scrollable page and drifts at a fraction of the scroll speed —
/// a subtle sense of depth (parallax) as the user scrolls, without ever
/// competing with the foreground content. Sections should keep a
/// transparent background so this layer reads through them.
class ParallaxBackground extends StatefulWidget {
  final ScrollController scrollController;
  const ParallaxBackground({super.key, required this.scrollController});

  @override
  State<ParallaxBackground> createState() => _ParallaxBackgroundState();
}

class _ParallaxBackgroundState extends State<ParallaxBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _drift;

  static const List<_OrbSpec> _orbs = [
    _OrbSpec(dx: -0.7, dyStart: 0.05, size: 300, parallaxFactor: 0.06, color: AppColors.sky, opacity: 0.10),
    _OrbSpec(dx: 0.8, dyStart: 0.30, size: 240, parallaxFactor: 0.11, color: AppColors.sand, opacity: 0.09),
    _OrbSpec(dx: -0.5, dyStart: 0.60, size: 260, parallaxFactor: 0.08, color: AppColors.olive, opacity: 0.08),
    _OrbSpec(dx: 0.5, dyStart: 0.90, size: 220, parallaxFactor: 0.12, color: AppColors.sky, opacity: 0.08),
  ];

  @override
  void initState() {
    super.initState();
    // A very slow ambient breathing loop so the background never feels
    // fully static even before the user starts scrolling.
    _drift = AnimationController(vsync: this, duration: const Duration(seconds: 40))..repeat();
  }

  @override
  void dispose() {
    _drift.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: ClipRect(
        child: Container(
          color: AppColors.navy,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final w = constraints.maxWidth;
              final h = constraints.maxHeight;
              // Loop range taller than the viewport so orbs recycle
              // smoothly as the page keeps scrolling.
              final loopHeight = h * 1.6;

              // One shared listenable drives both the slow idle drift and
              // the scroll-based parallax shift, so scrolling triggers a
              // single lightweight rebuild here instead of stacking an
              // extra setState on top of an already-running animation.
              return AnimatedBuilder(
                animation: Listenable.merge([_drift, widget.scrollController]),
                builder: (context, _) {
                  final breathe = _drift.value * 2 * math.pi;
                  final offset = widget.scrollController.hasClients
                      ? widget.scrollController.offset
                      : 0.0;
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      for (final orb in _orbs)
                        _buildOrb(orb, w, h, loopHeight, offset, breathe),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildOrb(
    _OrbSpec orb,
    double w,
    double h,
    double loopHeight,
    double scrollOffset,
    double breathe,
  ) {
    final baseY = orb.dyStart * loopHeight;
    final shifted = (baseY - scrollOffset * orb.parallaxFactor) % loopHeight;
    final y = shifted < 0 ? shifted + loopHeight : shifted;
    final wobble = math.sin(breathe + orb.dx * 5) * 10;

    final left = (w / 2) + (orb.dx * w / 2) - orb.size / 2 + wobble;

    return Positioned(
      left: left,
      top: y - orb.size / 2,
      child: Container(
        width: orb.size,
        height: orb.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              orb.color.withOpacity(orb.opacity),
              orb.color.withOpacity(0.0),
            ],
          ),
        ),
      ),
    );
  }
}
