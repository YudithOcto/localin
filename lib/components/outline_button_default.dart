import 'package:flutter/material.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';

class OutlineButtonDefault extends StatelessWidget {
  final String buttonText;
  final Function onPressed;
  final Color backgroundColor;
  final double width;
  final double height;
  final TextStyle textStyle;
  final Color textColor;
  final Color sideColor;
  final EdgeInsetsGeometry margin;

  OutlineButtonDefault({
    @required this.buttonText,
    @required this.onPressed,
    this.width = double.infinity,
    this.margin,
    this.height = 48.0,
    this.backgroundColor = ThemeColors.black0,
    this.textStyle = ThemeText.rodinaTitle3,
    this.textColor = ThemeColors.primaryBlue,
    this.sideColor = ThemeColors.primaryBlue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: margin,
      child: RaisedButton(
        elevation: 1.0,
        color: backgroundColor,
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
            side: BorderSide(
              color: sideColor,
            )),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          child: Text(
            '$buttonText',
            style: textStyle.copyWith(color: textColor),
          ),
        ),
      ),
    );
  }
}
