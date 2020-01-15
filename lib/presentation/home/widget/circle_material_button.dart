import 'package:flutter/material.dart';
import 'package:localin/presentation/profile/profile_page.dart';
import '../../../themes.dart';

class CircleMaterialButton extends StatelessWidget {
  final Function onPressed;
  final IconData icon;
  final Color iconColor, backgroundColor;
  final String imageAsset;
  final String title;

  CircleMaterialButton({
    @required this.onPressed,
    this.icon,
    this.iconColor = Colors.white,
    this.backgroundColor = Themes.primaryBlue,
    this.imageAsset,
    this.title,
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Column(
        children: <Widget>[
          Container(
            height: 50.0,
            width: 50.0,
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: backgroundColor),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: imageAsset != null
                  ? Image.asset(
                      imageAsset,
                      fit: BoxFit.contain,
                    )
                  : Icon(
                      icon,
                      color: iconColor,
                    ),
            ),
          ),
          Visibility(
            visible: title != null,
            child: SizedBox(
              height: 5.0,
            ),
          ),
          Visibility(
            visible: title != null,
            child: Text(
              '$title',
              style: kValueStyle.copyWith(
                color: Themes.darkGrey,
                fontSize: 12.0,
              ),
            ),
          )
        ],
      ),
    );
  }
}
