import 'package:flutter/material.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';

class CommunityBasicInfoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Basic',
            style: ThemeText.sfSemiBoldHeadline
                .copyWith(color: ThemeColors.black100),
          ),
          SizedBox(
            height: 8.0,
          ),
          Text(
            'Add name, description and locattion of your communnity so people will know what it’s about.',
            style: ThemeText.sfRegularBody.copyWith(color: ThemeColors.black80),
          ),
          SizedBox(
            height: 40.0,
          )
        ],
      ),
    );
  }
}
