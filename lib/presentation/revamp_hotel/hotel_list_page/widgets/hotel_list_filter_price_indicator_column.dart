import 'package:flutter/material.dart';
import 'package:localin/presentation/shared_widgets/subtitle.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';

class HotelListFilterPriceIndicatorColumn extends StatelessWidget {
  final String title;
  final double value;

  HotelListFilterPriceIndicatorColumn({this.title, this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Subtitle(
          title: 'highest',
        ),
        SizedBox(height: 12.0),
        Text('$value', style: ThemeText.sfRegularHeadline),
        SizedBox(height: 8.0),
        Container(
          color: ThemeColors.black20,
          width: double.maxFinite,
          height: 1.5,
        )
      ],
    );
  }
}
