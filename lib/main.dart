import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'widgets/hero_section.dart';
import 'widgets/stats_bar.dart';
import 'widgets/about_section.dart';
import 'widgets/skills_section.dart';
import 'widgets/experience_section.dart';
import 'widgets/certifications_section.dart';
import 'widgets/contact_section.dart';
import 'widgets/nav_bar.dart';
import 'widgets/scroll_progress_bar.dart';
import 'widgets/back_to_top_button.dart';
import 'widgets/parallax_background.dart';

void main() {
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ABIED',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.navy,
        useMaterial3: true,
        colorScheme: ColorScheme.dark(
          primary: AppColors.sky,
          secondary: AppColors.sand,
          surface: AppColors.navy,
        ),
      ),
      home: const PortfolioHome(),
    );
  }
}

class PortfolioHome extends StatefulWidget {
  const PortfolioHome({super.key});

  @override
  State<PortfolioHome> createState() => _PortfolioHomeState();
}

class _PortfolioHomeState extends State<PortfolioHome> {
  final _aboutKey = GlobalKey();
  final _skillsKey = GlobalKey();
  final _experienceKey = GlobalKey();
  final _certificationsKey = GlobalKey();
  final _contactKey = GlobalKey();
  final _scrollController = ScrollController();

  late final Map<String, GlobalKey> _sections = {
    'About': _aboutKey,
    'Expertise': _skillsKey,
    'Experience': _experienceKey,
    'Certifications': _certificationsKey,
    'Contact': _contactKey,
  };

  void _scrollTo(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Warm the profile photo into the image cache before it's first
    // painted, so the hero doesn't pop in a frame late.
    precacheImage(const AssetImage('assets/images/profile.png'), context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64 + 2.5),
        child: Column(
          children: [
            NavBar(sectionKeys: _sections),
            ScrollProgressBar(controller: _scrollController),
          ],
        ),
      ),
      floatingActionButton: BackToTopButton(controller: _scrollController),
      body: Stack(
        children: [
          Positioned.fill(
            child: RepaintBoundary(
              child: ParallaxBackground(scrollController: _scrollController),
            ),
          ),
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                const HeroSection(),
                StatsBar(scrollController: _scrollController),
                Container(
                  key: _aboutKey,
                  child: AboutSection(scrollController: _scrollController),
                ),
                Container(
                  key: _skillsKey,
                  child: SkillsSection(scrollController: _scrollController),
                ),
                Container(
                  key: _experienceKey,
                  child: ExperienceSection(scrollController: _scrollController),
                ),
                Container(
                  key: _certificationsKey,
                  child: CertificationsSection(scrollController: _scrollController),
                ),
                Container(
                  key: _contactKey,
                  child: ContactSection(scrollController: _scrollController),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
