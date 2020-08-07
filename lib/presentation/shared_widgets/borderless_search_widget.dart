import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';

class BorderlessSearchWidget extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final String title;
  final Color backgroundColor;
  final TextEditingController controller;
  final bool isShowPrefixIcon;
  final bool isAutoFocus;
  final bool isEnabled;
  BorderlessSearchWidget({
    this.onChanged,
    this.title,
    this.isAutoFocus = true,
    this.controller,
    this.backgroundColor = ThemeColors.black10,
    this.isShowPrefixIcon = false,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      autofocus: isAutoFocus,
      onChanged: onChanged,
      enabled: isEnabled,
      decoration: InputDecoration(
        prefixIconConstraints: BoxConstraints.loose(Size(60.0, 60.0)),
        prefixIcon: Visibility(
          visible: isShowPrefixIcon,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: SvgPicture.asset(
              'images/search_grey.svg',
            ),
          ),
        ),
        filled: true,
        fillColor: backgroundColor,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6.0),
            borderSide: BorderSide(color: ThemeColors.black0)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6.0),
            borderSide: BorderSide(color: ThemeColors.black0)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6.0),
            borderSide: BorderSide(color: ThemeColors.black0)),
        hintText: '$title',
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
        hintStyle: ThemeText.sfRegularBody.copyWith(color: ThemeColors.black60),
      ),
    );
  }
}
