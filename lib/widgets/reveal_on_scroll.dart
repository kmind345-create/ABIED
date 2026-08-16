import 'package:flutter/material.dart';

/// Fades + slides its child up the first time it scrolls into view,
/// then stays put. Listens to the page's [ScrollController] directly
/// (no extra package) and measures its own position each scroll tick.
class RevealOnScroll extends StatefulWidget {
  final Widget child;
  final ScrollController controller;

  /// Fraction of the viewport height at which the reveal fires —
  /// 0.88 means "fire once the widget's top has crossed 88% down the screen".
  final double triggerFraction;

  /// Fired once, at the moment the reveal animation starts — lets a
  /// child (e.g. an animated counter) sync its own effect to the exact
  /// instant this section enters view instead of running on page load.
  final VoidCallback? onReveal;

  const RevealOnScroll({
    super.key,
    required this.child,
    required this.controller,
    this.triggerFraction = 0.88,
    this.onReveal,
  });

  @override
  State<RevealOnScroll> createState() => _RevealOnScrollState();
}

class _RevealOnScrollState extends State<RevealOnScroll>
    with SingleTickerProviderStateMixin {
  final GlobalKey _key = GlobalKey();
  late final AnimationController _anim;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;
  bool _played = false;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _fade = CurvedAnimation(parent: _anim, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 40), end: Offset.zero)
        .animate(CurvedAnimation(parent: _anim, curve: Curves.easeOutCubic));
    widget.controller.addListener(_check);
    // also check once right after first layout, in case it's already
    // on screen (e.g. a short page, or a fast initial scroll position).
    WidgetsBinding.instance.addPostFrameCallback((_) => _check());
  }

  @override
  void dispose() {
    widget.controller.removeListener(_check);
    _anim.dispose();
    super.dispose();
  }

  void _check() {
    if (_played || !mounted) return;
    final ctx = _key.currentContext;
    final box = ctx?.findRenderObject() as RenderBox?;
    if (box == null || !box.attached) return;
    final position = box.localToGlobal(Offset.zero);
    final screenHeight = MediaQuery.of(context).size.height;
    if (position.dy < screenHeight * widget.triggerFraction) {
      _played = true;
      _anim.forward();
      widget.onReveal?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: _key,
      child: AnimatedBuilder(
        animation: _anim,
        builder: (context, child) {
          return Opacity(
            opacity: _fade.value,
            child: Transform.translate(
              offset: _slide.value,
              child: child,
            ),
          );
        },
        child: widget.child,
      ),
    );
  }
}
