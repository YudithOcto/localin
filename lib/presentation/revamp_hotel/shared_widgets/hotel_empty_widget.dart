import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localin/components/outline_button_default.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';

class HotelEmptyWidget extends StatelessWidget {
  final bool isVisible;
  final VoidCallback onTap;
  HotelEmptyWidget({this.isVisible = true, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SvgPicture.asset('images/empty_article.svg'),
        Text(
          'Can\'t find hotels',
          style:
              ThemeText.sfSemiBoldHeadline.copyWith(color: ThemeColors.black80),
        ),
        Text('Let’s explore more hotels around you.',
            style: ThemeText.sfRegularBody),
        Visibility(
          visible: isVisible,
          child: OutlineButtonDefault(
            onPressed: () => onTap,
            margin:
                const EdgeInsets.symmetric(horizontal: 48.0, vertical: 35.0),
            backgroundColor: ThemeColors.black10,
            buttonText: 'Search Hotel',
          ),
        )
      ],
    );
  }
}
