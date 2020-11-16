import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../text_themes.dart';
import '../../../themes.dart';

class RowUserCommunityArticleWidget extends StatelessWidget {
  final String icon;
  final String value;
  final String title;

  RowUserCommunityArticleWidget(
      {@required this.icon, this.value, @required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SvgPicture.asset(
          '$icon',
          width: 24.0,
          height: 24.0,
          fit: BoxFit.cover,
        ),
        SizedBox(
          width: 8.0,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '$value',
              style: ThemeText.sfSemiBoldTitle3
                  .copyWith(color: ThemeColors.black0),
            ),
            SizedBox(
              height: 4.0,
            ),
            Text(
              '$title',
              style:
                  ThemeText.sfSemiBoldBody.copyWith(color: ThemeColors.black0),
            ),
          ],
        ),
      ],
    );
  }
}
