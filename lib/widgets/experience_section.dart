import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../data/portfolio_data.dart';
import 'section_heading.dart';
import 'reveal_on_scroll.dart';

class ExperienceSection extends StatelessWidget {
  final ScrollController scrollController;
  const ExperienceSection({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = Breakpoints.isMobile(width);

    return Container(
      width: double.infinity,
      color: Colors.transparent,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 80,
        vertical: isMobile ? 60 : 96,
      ),
      child: RevealOnScroll(
        controller: scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeading(eyebrow: 'TIMELINE', title: 'Where I have worked'),
            const SizedBox(height: 36),
            // A single connecting line drawn behind the rows, instead of
            // per-row IntrinsicHeight segments — avoids overflow when
            // wrapped text makes each row's height unpredictable.
            Stack(
              children: [
                Positioned(
                  left: 6,
                  top: 7,
                  bottom: 26,
                  child: Container(width: 2, color: AppColors.sky.withOpacity(0.25)),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (int i = 0; i < PortfolioData.experience.length; i++)
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: i == PortfolioData.experience.length - 1 ? 0 : 36,
                        ),
                        child: _TimelineRow(item: PortfolioData.experience[i])
                            .animate()
                            .fadeIn(delay: (150 * i).ms)
                            .slideX(begin: -0.05, end: 0),
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TimelineRow extends StatelessWidget {
  final ExperienceItem item;
  const _TimelineRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 14,
          height: 14,
          margin: const EdgeInsets.only(top: 6),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.navy,
            border: Border.all(color: AppColors.sky, width: 2.5),
            boxShadow: [
              BoxShadow(color: AppColors.sky.withOpacity(0.5), blurRadius: 10),
            ],
          ),
        ),
        const SizedBox(width: 22),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.period, style: AppText.mono.copyWith(fontSize: 13.5)),
              const SizedBox(height: 6),
              Text(
                item.role,
                style: AppText.display.copyWith(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              Text(item.place, style: AppText.body.copyWith(color: AppColors.sand, fontSize: 16)),
              const SizedBox(height: 8),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 640),
                child: Text(item.desc, style: AppText.body.copyWith(fontSize: 15.5)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
