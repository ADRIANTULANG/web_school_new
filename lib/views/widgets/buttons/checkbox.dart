import 'package:flutter/material.dart';
import 'package:web_school/values/strings/colors.dart';

class CustomCheckbox extends StatelessWidget {
  const CustomCheckbox({
    Key? key,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  final bool? value;

  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      child: Container(
          height: 24.0,
          width: 24.0,
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Icon(
            Icons.check,
            color: value! ? ColorTheme.primaryRed : Colors.white,
            size: 15.0,
          )),
      onTap: () => onChanged(!value!),
    );
  }
}
