import 'dart:math' as math;
import 'package:flutter/material.dart';

/// A soft diagonal light sweep that glides across [child] every few
/// seconds, like light catching glass — the little "glint" you see on
/// premium app cards and buttons. Purely decorative and non-blocking
/// (IgnorePointer), so it never interferes with taps underneath.
class ShineEffect extends StatefulWidget {
  final Widget child;

  /// Clip shape. Use [BoxShape.circle] for round elements (e.g. the
  /// profile photo) and [BoxShape.rectangle] with [borderRadius] for
  /// cards, chips and badges.
  final BoxShape shape;
  final BorderRadius borderRadius;

  /// Total time between the start of one sweep and the next.
  final Duration cycle;

  /// Fraction of [cycle] the sweep is actually visible for — the rest
  /// is a pause, so cards don't shine continuously and distract.
  final double sweepFraction;

  /// 0..1 phase offset so a grid of cards doesn't all glint in unison.
  final double phase;

  /// Peak brightness of the sweep band. Keep this low — this is a
  /// glint, not a flash.
  final double intensity;

  const ShineEffect({
    super.key,
    required this.child,
    this.shape = BoxShape.rectangle,
    this.borderRadius = BorderRadius.zero,
    this.cycle = const Duration(milliseconds: 3600),
    this.sweepFraction = 0.3,
    this.phase = 0,
    this.intensity = 0.22,
  });

  @override
  State<ShineEffect> createState() => _ShineEffectState();
}

class _ShineEffectState extends State<ShineEffect>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.cycle);
    _controller.value = widget.phase % 1.0;
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _clip({required Widget child}) {
    if (widget.shape == BoxShape.circle) {
      return ClipOval(child: child);
    }
    return ClipRRect(borderRadius: widget.borderRadius, child: child);
  }

  @override
  Widget build(BuildContext context) {
    return _clip(
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          widget.child,
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  final t = _controller.value;
                  if (t > widget.sweepFraction) return const SizedBox.shrink();
                  final progress = t / widget.sweepFraction; // 0..1
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      final w = constraints.maxWidth;
                      final h = constraints.maxHeight;
                      if (w <= 0 || h <= 0) return const SizedBox.shrink();
                      final diagonal = math.sqrt(w * w + h * h);
                      final bandThickness = math.max(w, h) * 0.22;
                      final dx = -diagonal + progress * (diagonal * 2);
                      return Transform.translate(
                        offset: Offset(dx, 0),
                        child: Center(
                          child: Transform.rotate(
                            angle: -0.4,
                            child: Container(
                              width: bandThickness,
                              height: diagonal * 1.6,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Colors.white.withOpacity(0),
                                    Colors.white.withOpacity(widget.intensity),
                                    Colors.white.withOpacity(0),
                                  ],
                                  stops: const [0.0, 0.5, 1.0],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
