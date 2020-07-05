import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localin/components/outline_button_default.dart';
import 'package:localin/presentation/community/pages/community_create_edit_page.dart';
import 'package:localin/presentation/error_page/empty_page.dart';

import '../../text_themes.dart';
import '../../themes.dart';

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
            'Can\'t find community around me',
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
            onPressed: () async {
              Navigator.of(context).pushNamed(EmptyPage.routeName);
//              final result = await Navigator.of(context)
//                  .pushNamed(CommunityCreateEditPage.routeName, arguments: {
//                CommunityCreateEditPage.isUpdatePage: false,
//              });
//              if (result != null) {
//                /// refresh the page
//              }
            },
            buttonText: 'Create my own community',
          )
        ],
      ),
    );
  }
}
