import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../data/portfolio_data.dart';
import 'section_heading.dart';
import 'flip_badge_card.dart';
import 'reveal_on_scroll.dart';

class CertificationsSection extends StatelessWidget {
  final ScrollController scrollController;
  const CertificationsSection({super.key, required this.scrollController});

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
            const SectionHeading(eyebrow: 'CREDENTIALS', title: 'Certifications'),
            const SizedBox(height: 8),
            Text(
              isMobile ? 'Swipe to browse, tap a badge to flip it.' : 'Tap a badge to flip it.',
              style: AppText.body.copyWith(fontSize: 15, color: AppColors.sand),
            ),
            const SizedBox(height: 32),
            if (isMobile)
              // One badge per "page" so it swipes cleanly from card to
              // card instead of showing a sliver of the next one.
              SizedBox(
                height: 260,
                child: PageView.builder(
                  controller: PageController(viewportFraction: 1),
                  physics: const BouncingScrollPhysics(),
                  itemCount: PortfolioData.certifications.length,
                  itemBuilder: (context, i) => Center(
                    child: _buildBadge(
                      PortfolioData.certifications[i],
                      compact: true,
                      width: (width - 48).clamp(0, 320),
                    )
                        .animate()
                        .fadeIn(delay: (120 * i).ms)
                        .scale(begin: const Offset(0.9, 0.9)),
                  ),
                ),
              )
            else
              Wrap(
                spacing: 24,
                runSpacing: 24,
                children: [
                  for (int i = 0; i < PortfolioData.certifications.length; i++)
                    _buildBadge(PortfolioData.certifications[i])
                        .animate()
                        .fadeIn(delay: (120 * i).ms)
                        .scale(begin: const Offset(0.9, 0.9)),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(CertItem cert, {bool compact = false, double? width}) {
    return FlipBadgeCard(
      width: width ?? (compact ? 180 : 220),
      height: compact ? 260 : 280,
      front: BadgeFace(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.verified_outlined, color: AppColors.sky, size: 32),
            const SizedBox(height: 22),
            Text(
              cert.title,
              style: AppText.display.copyWith(fontSize: compact ? 28 : 34, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(cert.subtitle, style: AppText.body.copyWith(fontSize: 14.5)),
            const Spacer(),
            Text('TAP TO FLIP', style: AppText.mono.copyWith(fontSize: 11, color: AppColors.sand)),
          ],
        ),
      ),
      back: BadgeFace(
        accent: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ISSUER', style: AppText.mono.copyWith(fontSize: 11, color: AppColors.sky)),
            const SizedBox(height: 6),
            Text(cert.issuer, style: AppText.body.copyWith(fontSize: 16.5, color: AppColors.cream)),
            const SizedBox(height: 20),
            Text('YEAR', style: AppText.mono.copyWith(fontSize: 11, color: AppColors.sky)),
            const SizedBox(height: 6),
            Text(cert.year, style: AppText.body.copyWith(fontSize: 16.5, color: AppColors.cream)),
          ],
        ),
      ),
    );
  }
}
