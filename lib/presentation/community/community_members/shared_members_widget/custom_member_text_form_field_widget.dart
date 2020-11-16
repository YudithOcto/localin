import 'package:flutter/material.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';

class CustomMemberTextFormFieldWidget extends StatelessWidget {
  final Function(String) onChange;

  CustomMemberTextFormFieldWidget({@required this.onChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.0),
      child: TextFormField(
        onChanged: onChange,
        decoration: InputDecoration(
          filled: true,
          fillColor: ThemeColors.black10,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.0),
              borderSide: BorderSide(color: ThemeColors.black0)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.0),
              borderSide: BorderSide(color: ThemeColors.black0)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.0),
              borderSide: BorderSide(color: ThemeColors.black0)),
          hintText: 'Search by name',
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
          hintStyle:
              ThemeText.sfRegularBody.copyWith(color: ThemeColors.black60),
        ),
      ),
    );
  }
}
