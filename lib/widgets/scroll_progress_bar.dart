import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// A thin heartbeat-colored line that fills left→right as the page is
/// scrolled — gives constant, low-key feedback that the page is a long
/// scroll and shows exactly how far through it the reader is, which
/// matters most on a phone where there's no visible scrollbar.
class ScrollProgressBar extends StatefulWidget {
  final ScrollController controller;
  const ScrollProgressBar({super.key, required this.controller});

  @override
  State<ScrollProgressBar> createState() => _ScrollProgressBarState();
}

class _ScrollProgressBarState extends State<ScrollProgressBar> {
  double _progress = 0;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_update);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_update);
    super.dispose();
  }

  void _update() {
    if (!widget.controller.hasClients) return;
    final max = widget.controller.position.maxScrollExtent;
    final next = max <= 0 ? 0.0 : (widget.controller.offset / max).clamp(0.0, 1.0);
    if ((next - _progress).abs() > 0.001) {
      setState(() => _progress = next);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 2.5,
      width: double.infinity,
      child: Align(
        alignment: Alignment.centerLeft,
        child: FractionallySizedBox(
          widthFactor: _progress,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.sky.withOpacity(0.4), AppColors.skyGlow],
              ),
              boxShadow: [
                BoxShadow(color: AppColors.sky.withOpacity(0.6), blurRadius: 6),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
