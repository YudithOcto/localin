import 'package:flutter/material.dart';
import 'package:localin/utils/constants.dart';

import '../../../themes.dart';
import '../profile_page.dart';

class DescriptionColumn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            kRandomWords,
            textAlign: TextAlign.center,
            style: kValueStyle.copyWith(fontSize: 12.0),
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ImageIcon(
                ExactAssetImage('images/ic_fb_small.png'),
                color: Themes.primaryBlue,
                size: 30.0,
              ),
              SizedBox(
                width: 5.0,
              ),
              ImageIcon(
                ExactAssetImage('images/ic_google.png'),
                size: 30.0,
                color: Themes.primaryBlue,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
