import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';

class EmptyEvent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SvgPicture.asset('images/empty_community.svg'),
        SizedBox(height: 20.0),
        Text('Can’t find event or attraction around you',
            style: ThemeText.sfSemiBoldHeadline
                .copyWith(color: ThemeColors.black80)),
        SizedBox(height: 4.0),
        Text(
          'Discover community from other location, or create your own community',
          style: ThemeText.sfRegularBody.copyWith(color: ThemeColors.black80),
        )
      ],
    );
  }
}
