import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SectionHeading extends StatelessWidget {
  final String eyebrow;
  final String title;
  final bool center;

  const SectionHeading({
    super.key,
    required this.eyebrow,
    required this.title,
    this.center = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          center ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 28, height: 2, color: AppColors.sky),
            const SizedBox(width: 10),
            Text(eyebrow, style: AppText.mono.copyWith(fontSize: 13.5)),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          title,
          textAlign: center ? TextAlign.center : TextAlign.left,
          style: AppText.display.copyWith(fontSize: 40),
        ),
      ],
    );
  }
}
