import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localin/components/outline_button_default.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';

class HotelEmptyWidget extends StatelessWidget {
  final bool isVisible;
  final VoidCallback onTap;
  final String title;
  final String description;

  HotelEmptyWidget(
      {this.isVisible = true,
      this.onTap,
      this.title = 'Can\'t find hotels',
      this.description = 'Let’s explore more hotels around you.'});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 47.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SvgPicture.asset('images/empty_article.svg'),
          Text(
            '$title',
            style: ThemeText.sfSemiBoldHeadline
                .copyWith(color: ThemeColors.black80),
          ),
          SizedBox(height: 4.0),
          Text('$description',
              textAlign: TextAlign.center,
              style:
                  ThemeText.sfRegularBody.copyWith(color: ThemeColors.black80)),
          Visibility(
            visible: isVisible,
            child: OutlineButtonDefault(
              onPressed: onTap,
              margin: const EdgeInsets.symmetric(vertical: 35.0),
              backgroundColor: ThemeColors.black10,
              buttonText: 'Search Hotel',
            ),
          )
        ],
      ),
    );
  }
}
