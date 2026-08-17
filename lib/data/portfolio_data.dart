/// ============================================================
/// EDIT YOUR INFO HERE — everything on the page reads from this file.
/// ============================================================

class PortfolioData {
  // ---- Identity -------------------------------------------------
  static const String name = 'Ahmed Mohamed Abdullah';
  // Short form shown in the compact mobile nav pill (top of the page).
  static const String navShortName = 'Ahmed Abied';
  static const String title = 'Specialist Nurse';
  static const String subtitle =
      'Critical Care & Emergency Nursing — Mit Ghamr, Egypt';
  static const String tagline =
      'Steady hands, calm judgment, and close attention — '
      'for every patient, every shift.';

  // ---- Vitals-style stats (shown as a monitor readout) ----------
  static const List<Stat> stats = [
    Stat(label: 'YEARS EXP.', value: '5+'),
    Stat(label: 'PATIENTS / YR', value: '900+'),
    Stat(label: 'CERTIFICATIONS', value: '6'),
    Stat(label: 'SHIFTS COVERED', value: '1200+'),
  ];

  // ---- About ------------------------------------------------------
  static const String about =
      'I am a specialist nurse focused on critical and emergency care, '
      'working across intensive care units and emergency departments in '
      'Cairo. My work centers on precise clinical monitoring, fast, '
      'level-headed decisions under pressure, and treating every patient '
      'with the same care I would want for my own family. I believe good '
      'nursing is equal parts technical skill and steady presence.';

  // ---- Skills -------------------------------------------------------
  static const List<SkillItem> skills = [
    SkillItem(
      icon: 'monitor_heart',
      title: 'Critical Care Monitoring',
      desc: 'Continuous vitals tracking, early warning scoring, rapid escalation.',
    ),
    SkillItem(
      icon: 'medication',
      title: 'Medication Management',
      desc: 'IV therapy, precise dosage calculation, and reaction monitoring.',
    ),
    SkillItem(
      icon: 'emergency',
      title: 'Emergency Response',
      desc: 'Triage, CPR/ACLS protocols, and rapid stabilization under pressure.',
    ),
    SkillItem(
      icon: 'psychology',
      title: 'Patient Communication',
      desc: 'Clear, calm explanation for patients and families in high-stress moments.',
    ),
    SkillItem(
      icon: 'groups',
      title: 'Team Coordination',
      desc: 'Cross-shift handovers and close collaboration with physicians.',
    ),
    SkillItem(
      icon: 'fact_check',
      title: 'Clinical Documentation',
      desc: 'Accurate charting and compliance with hospital protocols.',
    ),
  ];

  // ---- Experience (real chronological order, oldest → newest) -----
  static const List<ExperienceItem> experience = [
    ExperienceItem(
      period: '2024 — Present',
      role: 'Specialist Nurse, ICU',
      place: 'Cairo University Hospitals',
      desc: 'Leading critical-care monitoring for post-operative and '
          'high-acuity patients across a 20-bed unit.',
    ),
    ExperienceItem(
      period: '2022 — 2024',
      role: 'Staff Nurse, Emergency Department',
      place: 'Ain Shams University Hospital',
      desc: 'Frontline triage and stabilization for high-volume emergency '
          'intake, averaging 60+ patients per shift.',
    ),
    ExperienceItem(
      period: '2021 — 2022',
      role: 'Nursing Intern',
      place: 'Kasr Al Ainy Hospital',
      desc: 'Rotated across internal medicine, surgery, and pediatrics '
          'wards to build broad clinical foundations.',
    ),
  ];

  // ---- Certifications (front/back flip cards) ----------------------
  static const List<CertItem> certifications = [
    CertItem(
      title: 'BLS',
      subtitle: 'Basic Life Support',
      issuer: 'American Heart Association',
      year: '2024',
    ),
    CertItem(
      title: 'ACLS',
      subtitle: 'Advanced Cardiac Life Support',
      issuer: 'American Heart Association',
      year: '2024',
    ),
    CertItem(
      title: 'CCRN',
      subtitle: 'Critical Care Registered Nurse',
      issuer: 'Egyptian Nursing Syndicate',
      year: '2023',
    ),
    CertItem(
      title: 'IVT',
      subtitle: 'IV Therapy & Infusion',
      issuer: 'Ministry of Health',
      year: '2022',
    ),
  ];

  // ---- Contact -------------------------------------------------------
  static const String phone = '01064044854';
  static const String location = 'Mit Ghamr, Egypt';
  static const String facebook =
      'https://www.facebook.com/share/1EK2aMUPFz/';
  static const String instagram =
      'https://www.instagram.com/ahmed.abied.74';
}

class Stat {
  final String label;
  final String value;
  const Stat({required this.label, required this.value});
}

class SkillItem {
  final String icon;
  final String title;
  final String desc;
  const SkillItem({required this.icon, required this.title, required this.desc});
}

class ExperienceItem {
  final String period;
  final String role;
  final String place;
  final String desc;
  const ExperienceItem({
    required this.period,
    required this.role,
    required this.place,
    required this.desc,
  });
}

class CertItem {
  final String title;
  final String subtitle;
  final String issuer;
  final String year;
  final String credentialId;
  const CertItem({
    required this.title,
    required this.subtitle,
    required this.issuer,
    required this.year,
    this.credentialId = 'Active — no expiry',
  });
}
