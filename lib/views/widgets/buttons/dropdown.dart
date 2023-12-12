import 'package:flutter/material.dart';
import 'package:web_school/models/option.dart';

class SchoolDropdown<T> extends StatelessWidget {
  const SchoolDropdown({
    required this.option,
    super.key,
  });

  final SelectionOption option;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            width: 1.0,
            color: Colors.black,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Text(
            option.label ?? "",
            style: theme.textTheme.bodyLarge!.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}
