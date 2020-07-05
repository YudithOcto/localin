import 'package:flutter/material.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';

class Subtitle extends StatelessWidget {
  final String title;
  Subtitle({this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      '${title.toUpperCase()}',
      style: ThemeText.sfSemiBoldFootnote.copyWith(color: ThemeColors.black80),
    );
  }
}
