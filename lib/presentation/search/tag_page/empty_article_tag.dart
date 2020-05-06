import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localin/themes.dart';

import '../../../text_themes.dart';

class EmptyArticleByTag extends StatelessWidget {
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
          'Can\'t find news with this tag',
          textAlign: TextAlign.center,
          style:
              ThemeText.sfSemiBoldHeadline.copyWith(color: ThemeColors.black80),
        ),
        SizedBox(
          height: 4.0,
        ),
        Text(
          'Read news from other tag',
          textAlign: TextAlign.center,
          style: ThemeText.sfRegularBody.copyWith(color: ThemeColors.black80),
        ),
      ],
    );
  }
}
