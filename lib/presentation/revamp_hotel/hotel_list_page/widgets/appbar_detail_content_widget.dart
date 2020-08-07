import 'package:flutter/material.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';

class AppBarDetailContentWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Hotel Nearby',
          style: ThemeText.sfMediumHeadline,
        ),
        Row(
          children: <Widget>[
            Text(
              '23 May - 24 May, 1 Night',
              style: ThemeText.sfMediumCaption,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                height: 12.0,
                width: 1.0,
                color: ThemeColors.black60,
              ),
            ),
            Expanded(
              child: Text(
                ' 1 Room, 1 Guest',
                style: ThemeText.sfMediumCaption,
              ),
            )
          ],
        )
      ],
    );
  }
}
