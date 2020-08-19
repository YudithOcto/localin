import 'package:flutter/material.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';

class SingleColumnBottomSheetSearchWidget extends StatelessWidget {
  final String title;
  final String value;
  SingleColumnBottomSheetSearchWidget({this.title, this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '$title',
          style:
              ThemeText.sfSemiBoldFootnote.copyWith(color: ThemeColors.black80),
        ),
        SizedBox(height: 5.0),
        Text(
          '$value',
          style:
              ThemeText.sfRegularHeadline.copyWith(color: ThemeColors.black100),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Container(
            color: ThemeColors.black20,
            height: 1.5,
            width: double.infinity,
          ),
        ),
      ],
    );
  }
}
