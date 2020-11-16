import 'package:flutter/material.dart';
import 'package:localin/text_themes.dart';

class RowPriceWidget extends StatelessWidget {
  final String title;
  final String value;
  final TextStyle valueStyle;

  RowPriceWidget({this.title, this.value, this.valueStyle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title,
            style: ThemeText.sfMediumHeadline,
          ),
          Text(
            value,
            style: valueStyle,
          ),
        ],
      ),
    );
  }
}
