import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localin/components/outline_button_default.dart';

import '../../../../text_themes.dart';
import '../../../../themes.dart';

class CommunityEmptyPage extends StatelessWidget {
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
            'Can\'t find community around you',
            textAlign: TextAlign.center,
            style: ThemeText.sfSemiBoldHeadline
                .copyWith(color: ThemeColors.black80),
          ),
          SizedBox(
            height: 4.0,
          ),
          Text(
            'Dicover community from other location, or create your own community',
            textAlign: TextAlign.center,
            style: ThemeText.sfRegularBody.copyWith(color: ThemeColors.black80),
          ),
          SizedBox(
            height: 16.0,
          ),
          OutlineButtonDefault(
            onPressed: () {},
            buttonText: 'Create my own community',
          )
        ],
      ),
    );
  }
}
