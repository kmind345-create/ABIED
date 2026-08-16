import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Wraps [child] with a tactile press-down scale + a light haptic tick.
/// This is what makes buttons, chips and cards feel "alive" under a
/// finger on a phone — a real press-in/release, not just a color change.
class PressScale extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double downScale;
  final bool haptic;
  final BorderRadius? borderRadius;

  const PressScale({
    super.key,
    required this.child,
    this.onTap,
    this.downScale = 0.94,
    this.haptic = true,
    this.borderRadius,
  });

  @override
  State<PressScale> createState() => _PressScaleState();
}

class _PressScaleState extends State<PressScale> {
  bool _down = false;

  void _setDown(bool v) {
    if (widget.onTap == null) return;
    setState(() => _down = v);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => _setDown(true),
      onTapCancel: () => _setDown(false),
      onTapUp: (_) => _setDown(false),
      onTap: widget.onTap == null
          ? null
          : () {
              if (widget.haptic) HapticFeedback.lightImpact();
              widget.onTap!();
            },
      child: MouseRegion(
        cursor: widget.onTap == null
            ? MouseCursor.defer
            : SystemMouseCursors.click,
        child: AnimatedScale(
          scale: _down ? widget.downScale : 1.0,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          child: widget.child,
        ),
      ),
    );
  }
}
