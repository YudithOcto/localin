import 'package:flutter/material.dart';
import 'package:localin/components/custom_image_radius.dart';
import 'package:localin/text_themes.dart';

class ExploreDetailLocationWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Location',
            style: ThemeText.sfSemiBoldHeadline,
          ),
          SizedBox(height: 8.0),
          CustomImageRadius(
            width: double.maxFinite,
            height: 179.0,
            radius: 8.0,
          ),
          SizedBox(height: 12.0),
          Text(
            'Pondok Indah Mall, Jalan Metro Pondok Indah, Kebayoran Lama, Jakarta Selatan, DKI Jakarta 12310, Indonesia',
            style: ThemeText.sfRegularBody,
          )
        ],
      ),
    );
  }
}
