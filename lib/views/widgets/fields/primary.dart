import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:web_school/values/strings/colors.dart';

class PrimaryTextField extends StatelessWidget {
  const PrimaryTextField({
    this.fieldKey,
    required this.controller,
    this.hintText,
    required this.label,
    this.textInput = TextInputType.name,
    this.validator,
    this.onChanged,
    this.prefixText,
    this.readOnly = false,
    this.onTap,
    this.inputFormatters,
    this.fontSize,
    this.prefixIcon,
    super.key,
  });

  final GlobalKey<FormFieldState>? fieldKey;
  final TextEditingController controller;
  final String? hintText;
  final String label;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final TextInputType textInput;
  final String? prefixText;
  final bool readOnly;
  final Function()? onTap;
  final List<TextInputFormatter>? inputFormatters;
  final double? fontSize;
  final Widget? prefixIcon;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 12.0),
        Text(label,
          style: theme.textTheme.bodyMedium!.copyWith(
            fontSize: fontSize ?? 14.0,
          ),
        ),
        const SizedBox(height: 4.0),
        TextFormField(
          key: fieldKey,
          onTapOutside: (PointerDownEvent event) {
            FocusScope.of(context).unfocus();
          },
          style: theme.textTheme.bodyMedium!,
          keyboardType: textInput,
          controller: controller,
          readOnly: readOnly,
          onTap: onTap,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 12.0,
            ),
            prefixText: prefixText,
            prefixStyle: TextStyle(
              color: ColorTheme.primaryBlack,
              fontWeight: FontWeight.bold,
            ),
            prefixIcon: prefixIcon,
            hintText: hintText,
            hintStyle: theme.textTheme.bodyMedium!
                .copyWith(color: ColorTheme.primaryRed.withOpacity(0.25)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(
                color: ColorTheme.primaryBlack,
              ),
            ),
          ),
          validator: validator,
          onChanged: (value) {

            if (onChanged != null) {
              onChanged!(value);
            }

            if (fieldKey?.currentState != null) {
              fieldKey!.currentState!.validate();
            }
          },
        ),
      ],
    );
  }
}
