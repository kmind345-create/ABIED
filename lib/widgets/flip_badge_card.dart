import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import 'shine_effect.dart';

/// A hospital-ID-badge-style card that flips in 3D on tap to reveal
/// its back face. Uses a real perspective matrix (not a fake scale
/// transition) so the flip has genuine depth.
class FlipBadgeCard extends StatefulWidget {
  final Widget front;
  final Widget back;
  final double width;
  final double height;

  const FlipBadgeCard({
    super.key,
    required this.front,
    required this.back,
    this.width = 220,
    this.height = 280,
  });

  @override
  State<FlipBadgeCard> createState() => _FlipBadgeCardState();
}

class _FlipBadgeCardState extends State<FlipBadgeCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _flipped = false;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    HapticFeedback.mediumImpact();
    setState(() => _flipped = !_flipped);
    if (_flipped) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggle,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) => setState(() => _pressed = false),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: AnimatedScale(
          scale: _pressed ? 0.95 : 1.0,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              final angle = _controller.value * math.pi;
              final showFront = angle < math.pi / 2;
              final displayAngle = showFront ? angle : angle - math.pi;
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.0018)
                  ..rotateY(displayAngle),
                child: SizedBox(
                  width: widget.width,
                  height: widget.height,
                  child: showFront ? widget.front : widget.back,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Shared card shell so front/back faces look consistent.
class BadgeFace extends StatelessWidget {
  final Widget child;
  final bool accent;
  const BadgeFace({super.key, required this.child, this.accent = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: accent
              ? [AppColors.navyLighter, AppColors.navyLight]
              : [AppColors.navyLight, AppColors.navy],
        ),
        border: Border.all(color: AppColors.sky.withOpacity(0.25)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: ShineEffect(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(18),
        cycle: const Duration(milliseconds: 3900),
        phase: accent ? 0.5 : 0,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: child,
        ),
      ),
    );
  }
}
