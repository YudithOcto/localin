import 'package:flutter/material.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';

class SmallCategoryWidget extends StatelessWidget {
  final double radius;
  final double verticalPadding;
  final double horizontalPadding;
  final String text;
  final TextStyle textTheme;
  final Color buttonBackgroundColor;
  final double marginLeft;

  SmallCategoryWidget({
    this.radius = 4.0,
    this.marginLeft = 0.0,
    this.verticalPadding = 8.0,
    this.horizontalPadding = 10.0,
    @required this.text,
    this.textTheme = ThemeText.sfMediumFootnote,
    this.buttonBackgroundColor = ThemeColors.black0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: marginLeft),
      alignment: FractionalOffset.center,
      padding: EdgeInsets.symmetric(
          vertical: verticalPadding, horizontal: horizontalPadding),
      decoration: BoxDecoration(
        color: buttonBackgroundColor,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: textTheme,
      ),
    );
  }
}
