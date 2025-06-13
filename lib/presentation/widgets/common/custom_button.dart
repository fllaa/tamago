import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final bool isOutlined;
  final bool isFullWidth;
  final double height;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final IconData? icon;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.isOutlined = false,
    this.isFullWidth = true,
    this.height = 56.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
    this.borderRadius = 8.0,
    this.icon,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final buttonStyle = isOutlined
        ? OutlinedButton.styleFrom(
            foregroundColor: textColor ?? Theme.of(context).colorScheme.primary,
            side: BorderSide(
              color: backgroundColor ?? Theme.of(context).colorScheme.primary,
              width: 2.0,
            ),
            padding: padding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            minimumSize: Size(isFullWidth ? double.infinity : 0, height),
          )
        : ElevatedButton.styleFrom(
            backgroundColor:
                backgroundColor ?? Theme.of(context).colorScheme.primary,
            foregroundColor:
                textColor ?? Theme.of(context).colorScheme.onPrimary,
            padding: padding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            minimumSize: Size(isFullWidth ? double.infinity : 0, height),
            elevation: 2,
          );

    final buttonContent = isLoading
        ? SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(
              color: isOutlined
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onPrimary,
              strokeWidth: 2.0,
            ),
          )
        : icon != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              )
            : Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              );

    return isOutlined
        ? OutlinedButton(
            onPressed: isLoading ? null : onPressed,
            style: buttonStyle,
            child: buttonContent,
          )
        : ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: buttonStyle,
            child: buttonContent,
          );
  }
}
