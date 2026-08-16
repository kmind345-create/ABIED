import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class _ParticleSpec {
  final IconData icon;
  final Alignment align;
  final double size;
  final double period; // seconds per drift loop
  final double phase;
  final double rotateAmp; // radians
  const _ParticleSpec({
    required this.icon,
    required this.align,
    required this.size,
    required this.period,
    required this.phase,
    this.rotateAmp = 0.35,
  });
}

/// A quiet layer of medical icons drifting and slowly turning in 3D
/// behind the hero content — atmosphere, not decoration that competes
/// with the text. Kept to low opacity on purpose.
class FloatingIcons extends StatefulWidget {
  const FloatingIcons({super.key});

  @override
  State<FloatingIcons> createState() => _FloatingIconsState();
}

class _FloatingIconsState extends State<FloatingIcons>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  static const List<_ParticleSpec> _specs = [
    _ParticleSpec(icon: Icons.monitor_heart_outlined, align: Alignment(-0.85, -0.7), size: 34, period: 9, phase: 0.0),
    _ParticleSpec(icon: Icons.vaccines_outlined, align: Alignment(0.9, -0.55), size: 28, period: 7, phase: 1.4),
    _ParticleSpec(icon: Icons.medical_services_outlined, align: Alignment(-0.7, 0.75), size: 30, period: 8, phase: 2.6),
    _ParticleSpec(icon: Icons.healing_outlined, align: Alignment(0.85, 0.8), size: 26, period: 10, phase: 0.9),
    _ParticleSpec(icon: Icons.favorite_border, align: Alignment(-0.15, -0.9), size: 22, period: 6.5, phase: 3.2),
    _ParticleSpec(icon: Icons.local_hospital_outlined, align: Alignment(0.15, 0.92), size: 24, period: 8.5, phase: 1.9),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 60))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final elapsed = _controller.value * 60; // seconds
          return Stack(
            children: [
              for (final spec in _specs)
                Align(
                  alignment: spec.align,
                  child: _Particle(spec: spec, elapsedSeconds: elapsed),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _Particle extends StatelessWidget {
  final _ParticleSpec spec;
  final double elapsedSeconds;
  const _Particle({required this.spec, required this.elapsedSeconds});

  @override
  Widget build(BuildContext context) {
    final t = (elapsedSeconds / spec.period) * 2 * math.pi + spec.phase;
    final driftY = math.sin(t) * 14;
    final driftX = math.cos(t * 0.6) * 10;
    final rotX = math.sin(t * 0.8) * spec.rotateAmp;
    final rotY = math.cos(t * 0.5) * spec.rotateAmp;

    return Transform.translate(
      offset: Offset(driftX, driftY),
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.0018)
          ..rotateX(rotX)
          ..rotateY(rotY),
        child: Icon(spec.icon, size: spec.size, color: AppColors.sky.withOpacity(0.16)),
      ),
    );
  }
}
