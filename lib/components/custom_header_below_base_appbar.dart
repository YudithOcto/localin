import 'package:flutter/material.dart';
import 'package:localin/presentation/profile/profile_page.dart';

import '../themes.dart';

class CustomHeaderBelowAppBar extends StatelessWidget {
  final String title;
  final Color color, iconColor;
  final IconData icon;

  CustomHeaderBelowAppBar({
    @required this.title,
    this.color = ThemeColors.primaryBlue,
    this.icon = Icons.keyboard_backspace,
    this.iconColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.1,
      color: color,
      child: Row(
        children: <Widget>[
          Visibility(
            visible: false,
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(icon, color: iconColor),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 20.0,
          ),
          Text(
            title,
            style: kValueStyle.copyWith(color: Colors.white, fontSize: 18.0),
          ),
        ],
      ),
    );
  }
}
