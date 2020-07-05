import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';

class UnderlineTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputAction inputAction;
  final TextInputType inputType;
  final Function(String) onChanged;
  final int maxInput;
  final Function onTap;
  final bool isFormDisabled;
  final List<TextInputFormatter> inputFormatter;

  UnderlineTextFormField({
    this.controller,
    this.inputAction = TextInputAction.none,
    this.maxInput,
    this.inputType,
    this.onChanged,
    this.isFormDisabled = false,
    this.onTap,
    this.inputFormatter,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: TextFormField(
        enabled: !isFormDisabled,
        controller: controller,
        inputFormatters: inputFormatter,
        maxLines: null,
        onChanged: onChanged,
        maxLength: maxInput,
        keyboardType: inputType,
        textInputAction: inputAction,
        style: ThemeText.sfRegularHeadline,
        decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: ThemeColors.black20, width: 1.5)),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: ThemeColors.black20, width: 1.5)),
          disabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: ThemeColors.black20, width: 1.5)),
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: ThemeColors.black20, width: 1.5),
          ),
        ),
      ),
    );
  }
}
