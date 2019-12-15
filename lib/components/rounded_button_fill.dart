import 'package:flutter/material.dart';
import 'package:localin/utils/constants.dart';

import '../themes.dart';

class RoundedButtonFill extends StatelessWidget {
  final Function onPressed;
  final String title;
  final Color titleColor, backgroundColor;
  final double fontSize;

  RoundedButtonFill(
      {@required this.onPressed,
      this.title,
      this.titleColor = Colors.white,
      this.backgroundColor = Themes.primaryBlue,
      this.fontSize = 12.0});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: backgroundColor, borderRadius: BorderRadius.circular(8.0)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
          child: Text(
            title,
            style: Constants.kValueStyle.copyWith(
                color: titleColor,
                fontSize: fontSize,
                letterSpacing: -.5,
                fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
