import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';

class CommunityCreateEventOnlineWidget extends StatelessWidget {
  final bool value;
  final Function(bool) onChanged;
  CommunityCreateEventOnlineWidget({this.value = false, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Online Event?',
                style: ThemeText.sfMediumBody,
              ),
              SizedBox(
                height: 4.0,
              ),
              Text(
                'Live streaming event',
                style: ThemeText.sfRegularFootnote,
              )
            ],
          ),
          CupertinoSwitch(
            onChanged: onChanged,
            trackColor: ThemeColors.black10,
            activeColor: ThemeColors.primaryBlue,
            value: value,
          ),
        ],
      ),
    );
  }
}
