import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localin/components/outline_button_default.dart';
import 'package:localin/presentation/community/community_discovery/community_discover_page.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';

class TransactionEmptyCommunityPage extends StatelessWidget {
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
            'Can’t find transactions',
            textAlign: TextAlign.center,
            style: ThemeText.sfSemiBoldHeadline
                .copyWith(color: ThemeColors.black80),
          ),
          SizedBox(
            height: 4.0,
          ),
          Text(
            'Let’s explore more community around you',
            textAlign: TextAlign.center,
            style: ThemeText.sfRegularBody.copyWith(color: ThemeColors.black80),
          ),
          SizedBox(
            height: 16.0,
          ),
          OutlineButtonDefault(
            onPressed: () {
              Navigator.of(context).pushNamed(CommunityDiscoverPage.routeName);
            },
            buttonText: 'Discover Community',
          )
        ],
      ),
    );
  }
}
