import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../data/portfolio_data.dart';
import 'reveal_on_scroll.dart';
import 'press_scale.dart';

class StatsBar extends StatefulWidget {
  final ScrollController scrollController;
  const StatsBar({super.key, required this.scrollController});

  @override
  State<StatsBar> createState() => _StatsBarState();
}

class _StatsBarState extends State<StatsBar> {
  bool _counting = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = Breakpoints.isMobile(width);

    return Container(
      width: double.infinity,
      color: Colors.transparent,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 80,
        vertical: 28,
      ),
      child: RevealOnScroll(
        controller: widget.scrollController,
        onReveal: () => setState(() => _counting = true),
        child: Wrap(
          alignment: WrapAlignment.spaceEvenly,
          runSpacing: 20,
          children: [
            for (int i = 0; i < PortfolioData.stats.length; i++)
              _StatBlock(stat: PortfolioData.stats[i], counting: _counting)
                  .animate()
                  .fadeIn(delay: (150 * i).ms)
                  .slideY(begin: 0.4, end: 0, curve: Curves.easeOut),
          ],
        ),
      ),
    );
  }
}

class _StatBlock extends StatelessWidget {
  final Stat stat;
  final bool counting;
  const _StatBlock({required this.stat, required this.counting});

  /// Splits e.g. "1200+" into (1200, "+") or "6" into (6, "") so the
  /// number can be tweened while the suffix stays put.
  (int, String) _split(String value) {
    final match = RegExp(r'^(\d+)(.*)$').firstMatch(value);
    if (match == null) return (0, value);
    return (int.parse(match.group(1)!), match.group(2) ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final parsed = _split(stat.value);
    final target = parsed.$1;
    final suffix = parsed.$2;
    return PressScale(
      onTap: () {},
      child: SizedBox(
        width: 160,
        child: Column(
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: counting ? target.toDouble() : 0),
              duration: const Duration(milliseconds: 1400),
              curve: Curves.easeOutCubic,
              builder: (context, value, _) {
                return Text(
                  '${value.round()}$suffix',
                  style: AppText.mono.copyWith(
                    fontSize: 34,
                    fontWeight: FontWeight.w700,
                    color: AppColors.cream,
                  ),
                );
              },
            ),
            const SizedBox(height: 4),
            Text(
              stat.label,
              style: AppText.mono.copyWith(fontSize: 12.5, color: AppColors.sky),
            ),
          ],
        ),
      ),
    );
  }
}
