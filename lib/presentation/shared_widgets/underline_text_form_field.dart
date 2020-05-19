import 'package:flutter/material.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';

class UnderlineTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputAction inputAction;
  final Function(String) onChanged;
  final int maxInput;

  UnderlineTextFormField(
      {this.controller,
      this.inputAction = TextInputAction.none,
      this.maxInput,
      this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: null,
      onChanged: onChanged,
      maxLength: maxInput,
      textInputAction: inputAction,
      style: ThemeText.sfRegularHeadline,
      decoration: InputDecoration(
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: ThemeColors.black20, width: 4.0),
        ),
      ),
    );
  }
}
