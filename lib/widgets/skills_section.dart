import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../data/portfolio_data.dart';
import 'section_heading.dart';
import 'tilt_3d.dart';
import 'reveal_on_scroll.dart';
import 'shine_effect.dart';

const Map<String, IconData> _iconMap = {
  'monitor_heart': Icons.monitor_heart_outlined,
  'medication': Icons.medication_outlined,
  'emergency': Icons.emergency_outlined,
  'psychology': Icons.psychology_outlined,
  'groups': Icons.groups_outlined,
  'fact_check': Icons.fact_check_outlined,
};

class SkillsSection extends StatefulWidget {
  final ScrollController scrollController;
  const SkillsSection({super.key, required this.scrollController});

  @override
  State<SkillsSection> createState() => _SkillsSectionState();
}

class _SkillsSectionState extends State<SkillsSection> {
  int? _activeIndex;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = Breakpoints.isMobile(width);
    final isTablet = Breakpoints.isTablet(width);
    final cols = isMobile ? 1 : (isTablet ? 2 : 3);

    return Container(
      width: double.infinity,
      color: Colors.transparent,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 80,
        vertical: isMobile ? 60 : 96,
      ),
      child: RevealOnScroll(
        controller: widget.scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeading(eyebrow: 'EXPERTISE', title: 'What I bring to a shift'),
            const SizedBox(height: 36),
            if (cols == 1)
              // Single column on mobile: let each card size itself to its
              // own text instead of forcing a fixed aspect-ratio box —
              // that's what was clipping the bottom line of longer
              // descriptions before.
              Column(
                children: [
                  for (int i = 0; i < PortfolioData.skills.length; i++) ...[
                    if (i > 0) const SizedBox(height: 20),
                    _buildCard(context, i),
                  ],
                ],
              )
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: PortfolioData.skills.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: cols,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 1.35,
                ),
                itemBuilder: (context, i) => _buildCard(context, i),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, int i) {
    final s = PortfolioData.skills[i];
    final active = _activeIndex == i;
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() => _activeIndex = active ? null : i);
      },
      child: Tilt3D(
        maxTiltDeg: 6,
        ambientAmplitude: 0.35,
        phase: i * 1.1,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: active ? AppColors.navyLighter : AppColors.navy,
            border: Border.all(
              color: active
                  ? AppColors.sky.withOpacity(0.75)
                  : AppColors.sky.withOpacity(0.15),
              width: active ? 1.6 : 1,
            ),
            boxShadow: active
                ? [
                    BoxShadow(
                      color: AppColors.sky.withOpacity(0.28),
                      blurRadius: 26,
                      spreadRadius: 1,
                    ),
                  ]
                : [],
          ),
          // Shine is a child of the decorated box (not a
          // wrapper around it) so its clip never cuts off
          // the glow shadow above.
          child: ShineEffect(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(16),
            phase: i * 0.22,
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedScale(
                    scale: active ? 1.12 : 1.0,
                    duration: const Duration(milliseconds: 260),
                    curve: Curves.easeOutBack,
                    child: Icon(
                      _iconMap[s.icon] ?? Icons.circle,
                      color: AppColors.sky,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    s.title,
                    style: AppText.display.copyWith(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Text(s.desc, style: AppText.body.copyWith(fontSize: 15)),
                ],
              ),
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: (90 * i).ms).slideY(begin: 0.15, end: 0);
  }
}
