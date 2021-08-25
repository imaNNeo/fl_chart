import 'package:flutter/material.dart';

class AppTextField extends TextFormField {
  AppTextField({
    Key? key,
    required String label,
    TextEditingController? controller,
    bool autoFocus = true,
    ValueChanged<String>? onFieldSubmitted,
    ValueChanged<String>? onTextChange,
    TextInputAction? textInputAction = TextInputAction.done,
    String? error,
    FocusNode? focusNode,
  }) : super(
    key: key,
    controller: controller,
    autofocus: autoFocus,
    onFieldSubmitted: onFieldSubmitted,
    textInputAction: textInputAction,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(fontSize: 18),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      errorText: error,
      border: OutlineInputBorder(),
    ),
    onChanged: onTextChange,
    focusNode: focusNode,
  );
}
