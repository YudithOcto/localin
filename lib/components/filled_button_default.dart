import 'package:flutter/material.dart';
import 'package:localin/themes.dart';

class FilledButtonDefault extends StatelessWidget {
  final bool isLoading;
  final String buttonText;
  final TextStyle textTheme;
  final Color backgroundColor;
  final Function onPressed;

  FilledButtonDefault({
    this.isLoading = false,
    @required this.buttonText,
    this.textTheme,
    this.backgroundColor = ThemeColors.primaryBlue,
    @required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.0,
      child: RaisedButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
        onPressed: onPressed,
        color: backgroundColor,
        child: !isLoading
            ? Text(
                buttonText,
                style: textTheme,
              )
            : Container(
                width: 24.0,
                height: 24.0,
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(ThemeColors.black0),
                  ),
                ),
              ),
      ),
    );
  }
}
