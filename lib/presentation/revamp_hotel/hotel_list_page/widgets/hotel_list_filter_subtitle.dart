import 'package:flutter/material.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';

class HotelListFilterSubtitle extends StatelessWidget {
  final String title;

  HotelListFilterSubtitle({this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 24.0, 20.0, 12.0),
      child: Text(title,
          style: ThemeText.sfSemiBoldHeadline
              .copyWith(color: ThemeColors.black80)),
    );
  }
}
