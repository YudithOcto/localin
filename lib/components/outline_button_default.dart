import 'package:flutter/material.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';

class OutlineButtonDefault extends StatelessWidget {
  final String buttonText;
  final Function onPressed;
  final Color backgroundColor;
  final double width;

  OutlineButtonDefault(
      {@required this.buttonText,
      @required this.onPressed,
      this.width = double.infinity,
      this.backgroundColor = ThemeColors.black0});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.0,
      width: width,
      child: RaisedButton(
        elevation: 1.0,
        color: backgroundColor,
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
            side: BorderSide(
              color: ThemeColors.primaryBlue,
            )),
        child: Text(
          '$buttonText',
          style:
              ThemeText.rodinaTitle3.copyWith(color: ThemeColors.primaryBlue),
        ),
      ),
    );
  }
}
