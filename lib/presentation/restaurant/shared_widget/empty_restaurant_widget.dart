import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';

class EmptyRestaurantWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final String subtitle;
  final bool isShowButton;

  EmptyRestaurantWidget({
    this.onPressed,
    this.title = 'Can\'t find restaurants',
    this.subtitle = 'Let’s explore more restaurants around me',
    this.isShowButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, left: 48.0, right: 48.0),
      child: Column(
        children: <Widget>[
          SvgPicture.asset(
            'images/empty_article.svg',
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: ThemeText.sfSemiBoldHeadline
                .copyWith(color: ThemeColors.black80),
          ),
          SizedBox(
            height: 4.0,
          ),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: ThemeText.sfRegularBody.copyWith(color: ThemeColors.black80),
          ),
          SizedBox(
            height: 16.0,
          ),
          Visibility(
            visible: isShowButton,
            child: InkResponse(
              highlightColor: ThemeColors.primaryBlue,
              onTap: onPressed,
              child: Container(
                margin: EdgeInsets.only(bottom: 20.0),
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                  border: Border.all(color: ThemeColors.primaryBlue),
                ),
                child: Text('Search Restaurants',
                    style: ThemeText.rodinaTitle3
                        .copyWith(color: ThemeColors.primaryBlue)),
              ),
            ),
          )
        ],
      ),
    );
  }
}
