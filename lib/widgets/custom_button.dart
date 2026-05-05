import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool expanded;
  final bool tonal;
  final bool danger;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.expanded = true,
    this.tonal = false,
    this.danger = false,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.onPressed == null;
    final foreground = widget.danger
        ? AppColors.danger
        : widget.tonal
            ? AppColors.primary
            : AppColors.textOnPrimary;

    final background = widget.danger
        ? AppColors.danger.withValues(alpha: 0.12)
        : widget.tonal
            ? AppColors.primary.withValues(alpha: 0.1)
            : AppColors.primary;

    final child = AnimatedScale(
      scale: _pressed && !isDisabled ? 0.98 : 1,
      duration: const Duration(milliseconds: 110),
      child: FilledButton.icon(
        onPressed: widget.onPressed,
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, 52),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          backgroundColor: background,
          disabledBackgroundColor: AppColors.border.withValues(alpha: 0.45),
          foregroundColor: foreground,
          disabledForegroundColor: AppColors.textSecondary.withValues(
            alpha: 0.55,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: Icon(
          widget.icon ?? Icons.circle,
          size: widget.icon == null ? 0 : 20,
        ),
        label: Text(
          widget.text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );

    return Listener(
      onPointerDown: (_) => setState(() => _pressed = true),
      onPointerUp: (_) => setState(() => _pressed = false),
      onPointerCancel: (_) => setState(() => _pressed = false),
      child: widget.expanded
          ? SizedBox(width: double.infinity, child: child)
          : child,
    );
  }
}
