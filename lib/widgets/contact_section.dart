import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';
import '../data/portfolio_data.dart';
import 'ecg_line.dart';
import 'reveal_on_scroll.dart';
import 'press_scale.dart';
import 'shine_effect.dart';

class ContactSection extends StatelessWidget {
  final ScrollController scrollController;
  const ContactSection({super.key, required this.scrollController});

  Future<void> _open(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = Breakpoints.isMobile(width);

    return Container(
      width: double.infinity,
      color: Colors.transparent,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 80,
        vertical: isMobile ? 60 : 100,
      ),
      child: RevealOnScroll(
        controller: scrollController,
        child: Column(
          children: [
            const EcgLine(height: 40),
            const SizedBox(height: 36),
            Text(
              "Let's work together",
              textAlign: TextAlign.center,
              style: AppText.display.copyWith(fontSize: isMobile ? 32 : 44),
            ),
            const SizedBox(height: 14),
            Text(
              'Available for hospital, clinic, and home-care placements.',
              textAlign: TextAlign.center,
              style: AppText.body.copyWith(fontSize: 17),
            ),
            const SizedBox(height: 32),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 14,
              runSpacing: 14,
              children: [
                _ContactChip(
                  icon: Icons.phone_outlined,
                  label: PortfolioData.phone,
                  onTap: () => _open('tel:${PortfolioData.phone.replaceAll(' ', '')}'),
                ).animate().fadeIn(delay: 0.ms).slideY(begin: 0.25, end: 0),
                _ContactChip(
                  icon: Icons.chat_outlined,
                  label: 'WhatsApp',
                  onTap: () => _open(
                    'https://wa.me/2${PortfolioData.phone.replaceAll(' ', '')}',
                  ),
                ).animate().fadeIn(delay: 90.ms).slideY(begin: 0.25, end: 0),
                _ContactChip(
                  icon: Icons.location_on_outlined,
                  label: PortfolioData.location,
                  onTap: null,
                ).animate().fadeIn(delay: 180.ms).slideY(begin: 0.25, end: 0),
                _ContactChip(
                  icon: Icons.facebook,
                  label: 'Facebook',
                  onTap: () => _open(PortfolioData.facebook),
                ).animate().fadeIn(delay: 270.ms).slideY(begin: 0.25, end: 0),
                _ContactChip(
                  icon: Icons.camera_alt_outlined,
                  label: 'Instagram',
                  onTap: () => _open(PortfolioData.instagram),
                ).animate().fadeIn(delay: 360.ms).slideY(begin: 0.25, end: 0),
              ],
            ),
            const SizedBox(height: 56),
            Text(
              '© ${DateTime.now().year} ${PortfolioData.name} — ${PortfolioData.title}',
              textAlign: TextAlign.center,
              style: AppText.mono.copyWith(fontSize: 12.5, color: AppColors.sand),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  const _ContactChip({required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return PressScale(
      onTap: onTap,
      downScale: 0.92,
      borderRadius: BorderRadius.circular(30),
      child: ShineEffect(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(30),
        cycle: const Duration(milliseconds: 4200),
        phase: label.length * 0.13,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: AppColors.sky.withOpacity(0.3)),
            color: AppColors.navyLight,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 17, color: AppColors.sky),
              const SizedBox(width: 8),
              Text(label, style: AppText.body.copyWith(fontSize: 14.5, color: AppColors.cream)),
            ],
          ),
        ),
      ),
    );
  }
}
