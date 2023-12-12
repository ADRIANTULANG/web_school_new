import 'package:flutter/material.dart';
import 'package:web_school/values/strings/colors.dart';
import 'package:web_school/values/strings/images.dart';

class PasswordTextField extends StatefulWidget {
  const PasswordTextField({
    this.fieldKey,
    required this.controller,
    required this.hintText,
    required this.label,
    this.validator,
    this.onChanged,
    this.prefixIcon,
    super.key,
  });

  final GlobalKey<FormFieldState>? fieldKey;
  final TextEditingController controller;
  final String hintText;
  final String label;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final Widget? prefixIcon;

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool showPass = true;

  void togglePassword() {
    setState(() {
      showPass = !showPass;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(widget.label),
        const SizedBox(height: 4.0),
        TextFormField(
          key: widget.fieldKey,
          onTapOutside: (PointerDownEvent event) =>
              FocusScope.of(context).unfocus(),
          controller: widget.controller,
          style: theme.textTheme.bodyMedium!,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 12.0,
            ),
            hintText: widget.hintText,
            hintStyle: theme.textTheme.bodyMedium!
                .copyWith(color: ColorTheme.primaryRed.withOpacity(0.25)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(
                color: ColorTheme.primaryBlack,
              ),
            ),
            prefixIcon: widget.prefixIcon,
            suffixIcon: IconButton(
              onPressed: togglePassword,
              icon: Image.asset(
                showPass ? PngImages.showPass : PngImages.hidePass,
                height: 30,
              ),
            ),
          ),
          obscureText: showPass,
          validator: widget.validator,
          onChanged: (value) => widget.fieldKey!.currentState!.validate(),
        ),
      ],
    );
  }
}
