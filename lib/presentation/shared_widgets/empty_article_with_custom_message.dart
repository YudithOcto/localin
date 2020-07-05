import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localin/themes.dart';

import '../../text_themes.dart';

class EmptyArticleWithCustomMessage extends StatelessWidget {
  final String title;
  final String message;
  EmptyArticleWithCustomMessage({@required this.title, @required this.message});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SvgPicture.asset(
          'images/empty_article.svg',
        ),
        Text(
          '$title',
          textAlign: TextAlign.center,
          style:
              ThemeText.sfSemiBoldHeadline.copyWith(color: ThemeColors.black80),
        ),
        SizedBox(
          height: 4.0,
        ),
        Text(
          '$message',
          textAlign: TextAlign.center,
          style: ThemeText.sfRegularBody.copyWith(color: ThemeColors.black80),
        ),
      ],
    );
  }
}
