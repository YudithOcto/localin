import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String title;
  final Color backgroundColor, textColor;
  final VoidCallback onPressed;
  final bool isCustomRounded;
  final TextAlign textAlign;
  final double borderRadius;
  final double elevation;
  final double height;
  final FontWeight fontWeight;
  final double fontSize;

  RoundedButton({
    this.title,
    this.backgroundColor,
    this.textColor,
    this.onPressed,
    this.isCustomRounded = true,
    this.textAlign = TextAlign.center,
    this.borderRadius = 5.0,
    this.elevation = 5.0,
    this.height = 50.0,
    this.fontWeight = FontWeight.w700,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      elevation: elevation,
      onPressed: onPressed,
      shape: isCustomRounded
          ? RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius))
          : StadiumBorder(),
      color: backgroundColor,
      child: Container(
        height: this.height,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: CustomText(
                title,
                fontSize: fontSize,
                textAlign: textAlign,
                fontWeight: fontWeight,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class IconedButton extends StatelessWidget {
  final String title;
  final String iconName;
  final Color backgroundColor, textColor;
  final VoidCallback onPressed;
  final bool isCustomRounded;

  IconedButton(
      {@required this.title,
      @required this.iconName,
      this.backgroundColor = Colors.blue,
      this.textColor = Colors.white,
      this.onPressed,
      this.isCustomRounded});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      elevation: 5.0,
      onPressed: onPressed,
      shape: isCustomRounded
          ? RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0))
          : StadiumBorder(),
      color: backgroundColor,
      child: Container(
        height: 40,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                iconName,
                width: 25,
                height: 25,
                fit: BoxFit.contain,
              ),
              Expanded(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomText extends StatelessWidget {
  final String text;
  final Color color;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final double fontSize;
  final int maxLines;
  final TextOverflow overflow;
  final double letterSpacing;

  CustomText(
    this.text, {
    this.textAlign = TextAlign.left,
    this.color = Colors.white,
    this.fontWeight = FontWeight.normal,
    this.fontSize = 14.0,
    this.maxLines,
    this.overflow,
    this.letterSpacing = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        text,
        textAlign: textAlign,
        style: TextStyle(
          color: color,
          fontWeight: fontWeight,
          fontSize: fontSize,
          letterSpacing: letterSpacing,
        ),
        maxLines: maxLines,
        overflow: overflow,
      ),
    );
  }
}
