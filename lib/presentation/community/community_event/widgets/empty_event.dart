import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';

class EmptyEvent extends StatelessWidget {
  final String text;
  EmptyEvent({@required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SvgPicture.asset(
          'images/empty_article.svg',
          fit: BoxFit.cover,
        ),
        Text(
          text,
          style:
              ThemeText.sfMediumHeadline.copyWith(color: ThemeColors.black80),
        )
      ],
    );
  }
}
