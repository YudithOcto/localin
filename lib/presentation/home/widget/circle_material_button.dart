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
    @required this.title,
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Column(
        children: <Widget>[
          Container(
            height: 60.0,
            width: 60.0,
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: Themes.primaryBlue),
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
          SizedBox(
            height: 5.0,
          ),
          Text(
            title,
            style: kValueStyle.copyWith(
              color: Themes.darkGrey,
              fontSize: 12.0,
            ),
          )
        ],
      ),
    );
  }
}
