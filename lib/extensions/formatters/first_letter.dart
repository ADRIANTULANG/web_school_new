
import 'package:flutter/services.dart';

class FirstLetterUppercaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Ensure that the first letter of each word is uppercase
    String newText = newValue.text;
    if (newText.isNotEmpty) {
      newText = newText.splitMapJoin(' ',
          onMatch: (match) => match.group(0)!.toUpperCase(),
          onNonMatch: (nonMatch) => nonMatch);
    }

    return TextEditingValue(
      text: newText,
      selection: newValue.selection,
    );
  }
}