import 'package:flutter/material.dart';
import '../core/constants/colors.dart';
import '../core/constants/text_styles.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final String? title;
  final Color? color;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.title,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: color ?? AppColors.cardWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
              child: Text(title!, style: AppTextStyles.labelBold),
            ),
          Padding(padding: padding ?? const EdgeInsets.all(20), child: child),
        ],
      ),
    );
  }
}
