import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../text_themes.dart';
import '../../../themes.dart';

class EmptyOtherUserCommunityWidget extends StatelessWidget {
  final String username;
  EmptyOtherUserCommunityWidget({this.username});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, left: 48.0, right: 48.0),
      child: Column(
        children: <Widget>[
          SvgPicture.asset(
            'images/empty_community.svg',
          ),
          Text(
            'Can\'t find $username community',
            textAlign: TextAlign.center,
            style: ThemeText.sfSemiBoldHeadline
                .copyWith(color: ThemeColors.black80),
          ),
          SizedBox(
            height: 4.0,
          ),
          Text(
            'User have not created or follow any community',
            textAlign: TextAlign.center,
            style: ThemeText.sfRegularBody.copyWith(color: ThemeColors.black80),
          ),
          SizedBox(
            height: 24.0,
          )
        ],
      ),
    );
  }
}
