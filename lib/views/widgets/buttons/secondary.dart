import 'package:flutter/material.dart';
import 'package:web_school/values/strings/colors.dart';

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    required this.onPressed,
    required this.label,
    this.backgroundColor,
    this.color,
    this.icon,
    this.isEnabled = true,
    super.key,
  });

  final Function() onPressed;
  final String label;
  final Color? backgroundColor;
  final Color? color;
  final Widget? icon;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return ElevatedButton(
      onPressed: isEnabled ? onPressed : null,
      style: ElevatedButton.styleFrom(
          padding: const  EdgeInsets.symmetric(vertical: 8.0),
          backgroundColor: backgroundColor ?? ColorTheme.primaryRed,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          )
      ),
      child: icon != null ? Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
              style: theme.textTheme.bodySmall!.copyWith(
                color: color ?? Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            icon!,
          ],
        ),
      ) : Text(label,
        style: theme.textTheme.bodySmall!.copyWith(
          color: color ?? Colors.white,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
