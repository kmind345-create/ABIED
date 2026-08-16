import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// A looping heartbeat trace, drawn like a bedside monitor.
/// This is the page's signature element — it appears as a divider
/// between sections and pulses gently, glowing in the photo's sky-blue.
class EcgLine extends StatefulWidget {
  final double height;
  const EcgLine({super.key, this.height = 60});

  @override
  State<EcgLine> createState() => _EcgLineState();
}

class _EcgLineState extends State<EcgLine> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: double.infinity,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            painter: _EcgPainter(progress: _controller.value),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

class _EcgPainter extends CustomPainter {
  final double progress;
  _EcgPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    final midY = size.height / 2;
    final w = size.width;

    // Build one heartbeat waveform, repeated to fill the width.
    List<Offset> buildBeat(double startX, double beatWidth) {
      return [
        Offset(startX, midY),
        Offset(startX + beatWidth * 0.14, midY),
        Offset(startX + beatWidth * 0.20, midY - size.height * 0.12),
        Offset(startX + beatWidth * 0.26, midY + size.height * 0.08),
        Offset(startX + beatWidth * 0.32, midY - size.height * 0.42),
        Offset(startX + beatWidth * 0.38, midY + size.height * 0.32),
        Offset(startX + beatWidth * 0.44, midY - size.height * 0.06),
        Offset(startX + beatWidth * 0.52, midY),
        Offset(startX + beatWidth, midY),
      ];
    }

    const beatWidth = 220.0;
    final beatCount = (w / beatWidth).ceil() + 2;
    // shift the whole trace left over time for a continuous scroll feel
    final shift = -progress * beatWidth;

    final points = <Offset>[];
    for (int i = 0; i < beatCount; i++) {
      points.addAll(buildBeat(shift + i * beatWidth, beatWidth));
    }

    path.moveTo(points.first.dx, points.first.dy);
    for (final p in points.skip(1)) {
      path.lineTo(p.dx, p.dy);
    }

    // glow (blurred underlay)
    final glowPaint = Paint()
      ..color = AppColors.sky.withOpacity(0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawPath(path, glowPaint);

    // crisp line on top
    final linePaint = Paint()
      ..color = AppColors.sky
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, linePaint);

    // baseline
    final basePaint = Paint()
      ..color = AppColors.sky.withOpacity(0.12)
      ..strokeWidth = 1;
    canvas.drawLine(Offset(0, midY), Offset(w, midY), basePaint);

    // a bright traveling dot at the current "read head"
    final dotX = w * ((math.sin(progress * math.pi * 2) + 1) / 2);
    canvas.drawCircle(
      Offset(dotX, midY),
      3.2,
      Paint()..color = AppColors.skyGlow,
    );
  }

  @override
  bool shouldRepaint(covariant _EcgPainter oldDelegate) => true;
}
