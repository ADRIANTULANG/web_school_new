import 'package:flutter/services.dart';

class StartWithLetterOrNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Ensure that the text starts with a letter or number
    if (newValue.text.isNotEmpty) {
      String firstChar = newValue.text[0];
      if (!RegExp(r'[a-zA-Z0-9]').hasMatch(firstChar)) {
        // If the first character is not a letter or number, replace it with an empty string
        return TextEditingValue(
          text: newValue.text.substring(1),
          selection: newValue.selection.copyWith(
            baseOffset: 0,
            extentOffset: 0,
          ),
        );
      }
    }

    return newValue;
  }
}