import 'package:flutter/material.dart';

import '../themes.dart';

class SocialButton extends StatelessWidget {
  final Function onPressed;
  final Color color, textColor, imageAssetColor;
  final String title, imageAsset;
  final double height;

  SocialButton(
      {@required this.onPressed,
      this.color = Themes.primaryBlue,
      this.textColor = Colors.white,
      this.imageAssetColor = Colors.white,
      this.height = 50.0,
      this.title,
      this.imageAsset});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: EdgeInsets.symmetric(horizontal: 30.0),
      child: RaisedButton(
        elevation: 5.0,
        onPressed: onPressed,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        color: color,
        child: Container(
          height: 40,
          child: Stack(
            children: <Widget>[
              Positioned(
                left: 0.0,
                top: 5.0,
                bottom: 5.0,
                child: Image.asset(
                  imageAsset,
                  width: 25,
                  height: 25,
                  color: imageAssetColor,
                  fit: BoxFit.contain,
                ),
              ),
              Align(
                alignment: FractionalOffset.center,
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
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
