import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

/// A pill FAB that appears once the reader has scrolled past the hero,
/// and smooth-scrolls back to the top on tap — a small but genuinely
/// useful piece of interactivity on a long single-page scroll.
class BackToTopButton extends StatefulWidget {
  final ScrollController controller;
  const BackToTopButton({super.key, required this.controller});

  @override
  State<BackToTopButton> createState() => _BackToTopButtonState();
}

class _BackToTopButtonState extends State<BackToTopButton> {
  bool _visible = false;

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
    final show = widget.controller.offset > 480;
    if (show != _visible) setState(() => _visible = show);
  }

  void _goTop() {
    HapticFeedback.lightImpact();
    widget.controller.animateTo(
      0,
      duration: const Duration(milliseconds: 650),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOut,
      offset: _visible ? Offset.zero : const Offset(0, 1.4),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 220),
        opacity: _visible ? 1 : 0,
        child: FloatingActionButton(
          onPressed: _visible ? _goTop : null,
          backgroundColor: AppColors.navyLighter,
          foregroundColor: AppColors.sky,
          elevation: 6,
          child: const Icon(Icons.keyboard_arrow_up_rounded, size: 28),
        ),
      ),
    );
  }
}
