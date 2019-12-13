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
    return RawMaterialButton(
      elevation: 5.0,
      onPressed: onPressed,
      fillColor: backgroundColor,
      shape: CircleBorder(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: imageAsset != null
            ? Image.asset(
                imageAsset,
                fit: BoxFit.cover,
                scale: 2.0,
              )
            : Icon(
                icon,
                color: iconColor,
              ),
      ),
    );
  }
}
