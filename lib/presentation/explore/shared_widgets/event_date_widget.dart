import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';

class EventDateWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: ThemeColors.black10,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SvgPicture.asset('images/calendar.svg'),
          SizedBox(width: 10.0),
          Text(
            'Wed, 08 April 2020 at 06:00 - 18:00',
            style: ThemeText.sfSemiBoldFootnote,
          )
        ],
      ),
    );
  }
}
