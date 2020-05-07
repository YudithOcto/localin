import 'package:flutter/material.dart';
import 'package:localin/utils/constants.dart';

import '../../../themes.dart';

class CommunityHeadingTitleWidget extends StatelessWidget {
  final String title;
  final Color color;
  final double textSize;

  CommunityHeadingTitleWidget(this.title,
      {this.color = ThemeColors.primaryBlue, this.textSize = 18.0});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '$title',
          style: kValueStyle.copyWith(
              fontWeight: FontWeight.w500, color: color, fontSize: textSize),
        ),
        SizedBox(
          height: 15.0,
        ),
      ],
    );
  }
}
