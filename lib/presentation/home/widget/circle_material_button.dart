import 'package:flutter/material.dart';
import '../../../themes.dart';

class CircleMaterialButton extends StatelessWidget {
  final Function onPressed;
  final IconData icon;
  final Color iconColor, backgroundColor;
  final String imageAsset;

  CircleMaterialButton(
      {this.onPressed,
      this.icon,
      this.iconColor = Colors.white,
      this.backgroundColor = Themes.primaryBlue,
      this.imageAsset});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.0,
      width: 60.0,
      decoration:
          BoxDecoration(shape: BoxShape.circle, color: Themes.primaryBlue),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: imageAsset != null
            ? Image.asset(
                imageAsset,
                fit: BoxFit.scaleDown,
                scale: 5.0,
              )
            : Icon(
                icon,
                color: iconColor,
              ),
      ),
    );
  }
}
