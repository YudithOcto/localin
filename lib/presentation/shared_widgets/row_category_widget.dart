import 'package:flutter/material.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';

class RowCategoryWidget extends StatelessWidget {
  final String title;
  RowCategoryWidget({@required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ThemeColors.yellow10,
        border: Border.all(color: ThemeColors.yellow40),
        borderRadius: BorderRadius.circular(4.0),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
      child: Text(
        '$title',
        style: ThemeText.sfMediumCaption.copyWith(color: ThemeColors.yellow60),
      ),
    );
  }
}
