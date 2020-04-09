import 'package:flutter/material.dart';
import 'package:localin/provider/auth_provider.dart';
import 'package:provider/provider.dart';

import '../../../themes.dart';
import '../profile_page.dart';

class DescriptionColumn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var state = Provider.of<AuthProvider>(context);
    return Container(
      margin: EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            state.userModel.shortBio,
            textAlign: TextAlign.center,
            style: kValueStyle.copyWith(fontSize: 12.0),
          ),
          SizedBox(
            height: 20.0,
          ),
          Visibility(
            visible: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ImageIcon(
                  ExactAssetImage('images/ic_fb_small.png'),
                  color: ThemeColors.primaryBlue,
                  size: 30.0,
                ),
                SizedBox(
                  width: 5.0,
                ),
                ImageIcon(
                  ExactAssetImage('images/ic_google.png'),
                  size: 30.0,
                  color: ThemeColors.primaryBlue,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
