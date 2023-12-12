import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  const CustomTextButton({
    required this.label,
    required this.onPressed,
    super.key,
  });

  final String label;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return TextButton(
      onPressed: onPressed,
      child: Text(
        label,
        style: theme.textTheme.bodyMedium!.copyWith(
          color: Colors.white,
        ),
      ),
    );
  }
}
