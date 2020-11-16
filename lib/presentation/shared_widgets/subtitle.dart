import 'package:flutter/material.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';

class Subtitle extends StatelessWidget {
  final String title;
  final bool isNeedUpperCase;

  Subtitle({this.title, this.isNeedUpperCase = true});

  @override
  Widget build(BuildContext context) {
    return Text(
      '${isNeedUpperCase ? title.toUpperCase() : title}',
      style: ThemeText.sfSemiBoldFootnote.copyWith(color: ThemeColors.black80),
    );
  }
}
