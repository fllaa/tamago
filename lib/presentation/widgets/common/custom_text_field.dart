import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? labelText;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final int maxLines;
  final int? maxLength;
  final bool enabled;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final AutovalidateMode autovalidateMode;
  final FocusNode? focusNode;
  final bool autofocus;
  final EdgeInsetsGeometry? contentPadding;
  final BoxConstraints? prefixIconConstraints;
  final BoxConstraints? suffixIconConstraints;
  final TextCapitalization textCapitalization;
  final bool readOnly;
  final VoidCallback? onTap;
  final Color? fillColor;
  final bool? filled;

  const CustomTextField({
    super.key,
    required this.controller,
    this.labelText,
    this.hintText,
    this.helperText,
    this.errorText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.maxLines = 1,
    this.maxLength,
    this.enabled = true,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.inputFormatters,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.focusNode,
    this.autofocus = false,
    this.contentPadding,
    this.prefixIconConstraints,
    this.suffixIconConstraints,
    this.textCapitalization = TextCapitalization.none,
    this.readOnly = false,
    this.onTap,
    this.fillColor,
    this.filled,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        helperText: helperText,
        errorText: errorText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        filled: filled ?? true,
        fillColor: fillColor ?? Theme.of(context).inputDecorationTheme.fillColor,
        contentPadding: contentPadding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        prefixIconConstraints: prefixIconConstraints,
        suffixIconConstraints: suffixIconConstraints,
        errorMaxLines: 2,
      ),
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      maxLines: maxLines,
      maxLength: maxLength,
      enabled: enabled,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      validator: validator,
      inputFormatters: inputFormatters,
      autovalidateMode: autovalidateMode,
      focusNode: focusNode,
      autofocus: autofocus,
      textCapitalization: textCapitalization,
      readOnly: readOnly,
      onTap: onTap,
      style: TextStyle(
        fontSize: 16,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}