import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localin/components/outline_button_default.dart';
import 'package:localin/presentation/error_page/empty_page.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';

class EmptyArticle extends StatelessWidget {
  final String title;
  final String message;
  final bool isShowButton;
  final Function onPressed;

  EmptyArticle({
    this.title = 'Can\'t find news around you',
    this.message = 'Read news from other location, or create your own article',
    this.isShowButton = true,
    this.onPressed,
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
            '$title',
            textAlign: TextAlign.center,
            style: ThemeText.sfSemiBoldHeadline
                .copyWith(color: ThemeColors.black80),
          ),
          SizedBox(
            height: 4.0,
          ),
          Text(
            '$message',
            textAlign: TextAlign.center,
            style: ThemeText.sfRegularBody.copyWith(color: ThemeColors.black80),
          ),
          SizedBox(
            height: 16.0,
          ),
          Visibility(
            visible: isShowButton,
            child: OutlineButtonDefault(
              onPressed: () async {
                if (onPressed != null) {
                  onPressed();
                } else {
                  Navigator.of(context).pushNamed(EmptyPage.routeName);
                }
//              final result = await Navigator.of(context)
//                  .pushNamed(CreateArticlePage.routeName);
//              if (result != null) {
//                /// refresh current page
//              }
              },
              buttonText: 'Create Article',
            ),
          )
        ],
      ),
    );
  }
}
