import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localin/components/outline_button_default.dart';
import 'package:localin/themes.dart';

import '../../../text_themes.dart';

class EmptyInboxWidget extends StatelessWidget {
  final ValueChanged<int> valueChanged;
  EmptyInboxWidget({this.valueChanged});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: ThemeColors.black10,
      width: double.infinity,
      height: MediaQuery.of(context).size.height * .7,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(child: SvgPicture.asset('images/inbox_empty.svg')),
          Container(
            margin: EdgeInsets.only(top: 18.0, bottom: 4.0),
            child: Text(
              'Can\'t find notification',
              style: ThemeText.sfSemiBoldHeadline
                  .copyWith(color: ThemeColors.black80),
            ),
          ),
          Text(
            'Let\'s explore more content around you.',
            style: ThemeText.sfRegularBody.copyWith(color: ThemeColors.black80),
          ),
          SizedBox(
            height: 35.0,
          ),
          OutlineButtonDefault(
            width: 240.0,
            buttonText: 'Back to Feed',
            onPressed: () {
              valueChanged(0);
            },
            backgroundColor: ThemeColors.black10,
          )
        ],
      ),
    );
  }
}
