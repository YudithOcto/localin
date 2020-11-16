import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localin/text_themes.dart';

class BottomRowWidget extends StatelessWidget {
  final String icon;
  final String title;

  BottomRowWidget({@required this.icon, @required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SvgPicture.asset(icon),
          SizedBox(width: 8.0),
          Text(
            title,
            style: ThemeText.sfSemiBoldBody,
          )
        ],
      ),
    );
  }
}
