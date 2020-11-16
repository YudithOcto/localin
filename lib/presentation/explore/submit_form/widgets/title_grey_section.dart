import 'package:flutter/material.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';

class TitleGreySection extends StatelessWidget {
  final String title;

  TitleGreySection({this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.maxFinite,
        padding: const EdgeInsets.all(12.0),
        color: ThemeColors.black20,
        child: Text('${title.toUpperCase()}',
            style: ThemeText.sfSemiBoldFootnote
                .copyWith(color: ThemeColors.black80)));
  }
}
