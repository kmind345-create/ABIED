import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Wraps [child] in a real perspective transform (Matrix4, not a fake
/// scale trick) that tilts toward the pointer on desktop.
///
/// On phones there is no mouse to hover with, so [ambient] drives a
/// slow, continuous idle tilt/breathing loop on its own — the card
/// visibly moves in 3D the moment the page opens, and a finger drag
/// takes over control for as long as it's active.
class Tilt3D extends StatefulWidget {
  final Widget child;
  final double maxTiltDeg;
  final double scaleOnHover;

  /// Plays a gentle automatic 3D tilt loop when nothing is actively
  /// hovering/dragging — this is what makes the effect visible on mobile.
  final bool ambient;

  /// 0..1 — how much of [maxTiltDeg] the ambient loop swings through.
  final double ambientAmplitude;

  /// Seconds for one full ambient cycle.
  final double ambientPeriod;

  /// Offsets the ambient loop's starting phase so multiple cards
  /// (e.g. a grid) don't all move in perfect unison.
  final double phase;

  const Tilt3D({
    super.key,
    required this.child,
    this.maxTiltDeg = 8,
    this.scaleOnHover = 1.02,
    this.ambient = true,
    this.ambientAmplitude = 0.5,
    this.ambientPeriod = 6,
    this.phase = 0,
  });

  @override
  State<Tilt3D> createState() => _Tilt3DState();
}

class _Tilt3DState extends State<Tilt3D> with SingleTickerProviderStateMixin {
  Offset _pointer = Offset.zero; // -1..1, from mouse hover or finger drag
  bool _active = false; // true while hovering (desktop) or dragging (touch)
  late final AnimationController _ambient;

  @override
  void initState() {
    super.initState();
    _ambient = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (widget.ambientPeriod * 1000).round()),
    );
    if (widget.ambient) _ambient.repeat();
  }

  @override
  void dispose() {
    _ambient.dispose();
    super.dispose();
  }

  void _updatePointer(Offset localPosition, Size size) {
    if (size.width == 0 || size.height == 0) return;
    final dx = (localPosition.dx / size.width) * 2 - 1;
    final dy = (localPosition.dy / size.height) * 2 - 1;
    setState(() => _pointer = Offset(dx.clamp(-1, 1), dy.clamp(-1, 1)));
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _active = true),
      onExit: (_) => setState(() {
        _active = false;
        _pointer = Offset.zero;
      }),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = Size(constraints.maxWidth, constraints.maxHeight);
          return GestureDetector(
            onPanStart: (_) => setState(() => _active = true),
            onPanUpdate: (d) => _updatePointer(d.localPosition, size),
            onPanEnd: (_) => setState(() {
              _active = false;
              _pointer = Offset.zero;
            }),
            onPanCancel: () => setState(() {
              _active = false;
              _pointer = Offset.zero;
            }),
            child: Listener(
              onPointerHover: (e) => _updatePointer(e.localPosition, size),
              child: AnimatedBuilder(
                animation: _ambient,
                builder: (context, child) {
                  double dx, dy, scale;
                  if (_active) {
                    dx = _pointer.dx;
                    dy = _pointer.dy;
                    scale = widget.scaleOnHover;
                  } else if (widget.ambient) {
                    final t = _ambient.value * 2 * math.pi + widget.phase;
                    dx = math.sin(t) * widget.ambientAmplitude;
                    dy = math.cos(t * 0.7) * widget.ambientAmplitude * 0.6;
                    scale = 1.0 + math.sin(t).abs() * 0.008;
                  } else {
                    dx = 0;
                    dy = 0;
                    scale = 1.0;
                  }
                  return Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.0012) // perspective
                      ..rotateX(-dy * widget.maxTiltDeg * math.pi / 180)
                      ..rotateY(dx * widget.maxTiltDeg * math.pi / 180)
                      ..scale(scale),
                    child: child,
                  );
                },
                child: widget.child,
              ),
            ),
          );
        },
      ),
    );
  }
}
