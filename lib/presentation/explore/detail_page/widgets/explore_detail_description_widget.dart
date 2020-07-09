import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localin/presentation/explore/shared_widgets/custom_category_radius.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';

class ExploreDetailDescriptionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CustomCategoryRadius(
            width: 80,
            height: 28.0,
            radius: 100.0,
            marginTop: 16.0,
            buttonBackgroundColor: ThemeColors.blue10,
            text: 'Attraction',
            textTheme: ThemeText.sfSemiBoldFootnote
                .copyWith(color: ThemeColors.blue60),
          ),
          SizedBox(height: 8.0),
          Text('Magic Art 3D Museum Jakarta Tickets ',
              style: ThemeText.rodinaTitle2),
          SizedBox(height: 4.58),
          Row(
            children: <Widget>[
              SvgPicture.asset(
                'images/location.svg',
                width: 13,
                height: 16,
              ),
              SizedBox(width: 7.33),
              Text(
                'Pondok Indah, Jakarta Selatan',
                style: ThemeText.sfRegularBody
                    .copyWith(color: ThemeColors.black80),
              )
            ],
          ),
          SizedBox(height: 25.67),
          Text(
            'What You’ll Experience',
            style: ThemeText.sfSemiBoldHeadline,
          ),
          SizedBox(height: 8.0),
          Text(
            'Let your kids having a good time to learn and play with Jackids '
            'Playground Alam Sutera Tickets. A range of attractions, '
            'from trampoline, puppet, ball pool, slide, to various educational '
            'zone are here to excite your little ones',
            style: ThemeText.sfRegularBody,
          )
        ],
      ),
    );
  }
}
