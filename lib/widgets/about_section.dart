import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../data/portfolio_data.dart';
import 'section_heading.dart';
import 'reveal_on_scroll.dart';

class AboutSection extends StatelessWidget {
  final ScrollController scrollController;
  const AboutSection({super.key, required this.scrollController});

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
            const SectionHeading(eyebrow: 'ABOUT', title: 'Who I am'),
            const SizedBox(height: 28),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: Text(
                PortfolioData.about,
                style: AppText.body.copyWith(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
