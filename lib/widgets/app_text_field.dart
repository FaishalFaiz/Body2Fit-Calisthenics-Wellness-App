import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Input teks dengan label di atas dan ikon di dalam field.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.prefixIcon,
    this.suffix,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.autofillHints,
    this.focusNode,
    this.enabled = true,
    this.onFieldSubmitted,
    this.labelTrailing,
  });

  final String label;
  final Widget? labelTrailing;
  final String? hint;
  final TextEditingController? controller;
  final IconData? prefixIcon;
  final Widget? suffix;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final Iterable<String>? autofillHints;
  final FocusNode? focusNode;
  final bool enabled;
  final ValueChanged<String>? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              label,
              style: AppText.bodySm.copyWith(
                color: AppColors.onSurfaceVariant,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
            if (labelTrailing != null) ...<Widget>[
              const Spacer(),
              labelTrailing!,
            ],
          ],
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          enabled: enabled,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          validator: validator,
          autofillHints: autofillHints,
          onFieldSubmitted: onFieldSubmitted,
          style: AppText.body.copyWith(
            color: AppColors.onSurface,
            fontSize: 13.5,
          ),
          cursorColor: AppColors.primary,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: prefixIcon == null
                ? null
                : Icon(prefixIcon, size: 18, color: AppColors.onSurfaceVariant),
            prefixIconConstraints: const BoxConstraints(minWidth: 42, minHeight: 20),
            suffixIcon: suffix,
            suffixIconConstraints: const BoxConstraints(minWidth: 42, minHeight: 20),
          ),
        ),
      ],
    );
  }
}
