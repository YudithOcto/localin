import 'package:flutter/material.dart';

import '../../../../text_themes.dart';
import '../../../../themes.dart';

class SingleConfirmationRow extends StatelessWidget {
  final String title;
  final String value;

  SingleConfirmationRow(this.title, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            flex: 4,
            child: Text(
              title,
              style: ThemeText.sfMediumFootnote
                  .copyWith(color: ThemeColors.black80),
            ),
          ),
          SizedBox(width: 10.0),
          Flexible(
              flex: 6, child: Text(value, style: ThemeText.sfMediumFootnote)),
        ],
      ),
    );
  }
}
