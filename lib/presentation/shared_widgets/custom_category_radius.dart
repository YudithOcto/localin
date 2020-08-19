import 'package:flutter/material.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';

class CustomCategoryRadius extends StatelessWidget {
  final double radius;
  final double verticalPadding;
  final double horizontalPadding;
  final String text;
  final TextStyle textTheme;
  final Color buttonBackgroundColor;
  final double marginLeft;
  final double marginRight;
  final double marginTop;
  final double marginBottom;
  final double width;
  final double height;

  CustomCategoryRadius(
      {this.radius = 4.0,
      this.marginLeft = 0.0,
      this.marginRight = 0.0,
      this.verticalPadding = 8.0,
      this.horizontalPadding = 10.0,
      @required this.text,
      this.textTheme = ThemeText.sfMediumFootnote,
      this.buttonBackgroundColor = ThemeColors.black0,
      this.marginTop = 0.0,
      this.marginBottom = 0.0,
      this.height,
      this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: EdgeInsets.only(
          left: marginLeft,
          right: marginRight,
          top: marginTop,
          bottom: marginBottom),
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
