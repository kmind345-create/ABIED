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
              'Tap a badge to flip it.',
              style: AppText.body.copyWith(fontSize: 15, color: AppColors.sand),
            ),
            const SizedBox(height: 32),
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

  Widget _buildBadge(CertItem cert) {
    return FlipBadgeCard(
      front: BadgeFace(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.verified_outlined, color: AppColors.sky, size: 32),
            const Spacer(),
            Text(
              cert.title,
              style: AppText.display.copyWith(fontSize: 34, fontWeight: FontWeight.w700),
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
          mainAxisAlignment: MainAxisAlignment.center,
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
