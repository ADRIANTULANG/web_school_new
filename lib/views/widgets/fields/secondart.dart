import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SecondaryTextField extends StatelessWidget {
  const SecondaryTextField({
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
    super.key,
  });

  final GlobalKey<FormFieldState>? fieldKey;
  final TextEditingController controller;
  final String? hintText;
  final String label;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final TextInputType textInput;
  final String? prefixText;
  final bool readOnly;
  final Function()? onTap;
  final List<TextInputFormatter>? inputFormatters;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Text(label,
            style: theme.textTheme.bodyMedium!.copyWith(
              fontSize: fontSize ?? 14.0,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 4.0),
        Expanded(
          child: TextFormField(

            key: fieldKey,
            onTapOutside: (PointerDownEvent event) {
              FocusScope.of(context).unfocus();
            },
            style: theme.textTheme.bodySmall!.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
            keyboardType: textInput,
            controller: controller,
            readOnly: readOnly,
            onTap: onTap,
            inputFormatters: inputFormatters,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 0.0,
              ),
              hintText: hintText,
              hintStyle: theme.textTheme.bodyMedium!.copyWith(
                color: Colors.grey,
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                ),
              ),

            ),
            validator: validator,
            onChanged: (value) {
              if (fieldKey?.currentState != null) {
                fieldKey!.currentState!.validate();
              }
            },
          ),
        ),
      ],
    );
  }
}
