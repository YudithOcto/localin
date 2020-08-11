import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localin/presentation/shared_widgets/custom_rating_widget.dart';
import 'package:localin/presentation/shared_widgets/row_category_widget.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';

class HotelDetailOverviewWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      color: ThemeColors.black0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              CustomRatingWidget(
                starRating: '4.5',
                totalRating: '140',
              ),
              Row(
                children: <Widget>[
                  SvgPicture.asset(
                    'images/location.svg',
                  ),
                  SizedBox(width: 7.0),
                  Text(
                    'View in Map',
                    style: ThemeText.sfMediumCaption
                        .copyWith(color: ThemeColors.black80),
                  )
                ],
              )
            ],
          ),
          SizedBox(height: 11.0),
          Text('OYO Life 2736 Pondok Klara', style: ThemeText.rodinaTitle3),
          SizedBox(height: 2.0),
          RichText(
            text: TextSpan(children: [
              TextSpan(
                text: 'Near Griya Mitra Park, Bandung',
                style: ThemeText.sfMediumFootnote
                    .copyWith(color: ThemeColors.black80),
              ),
              TextSpan(
                  text: ' • ',
                  style: ThemeText.sfMediumFootnote
                      .copyWith(color: ThemeColors.black80)),
              TextSpan(
                  text: '1.5km',
                  style: ThemeText.sfMediumFootnote
                      .copyWith(color: ThemeColors.primaryBlue)),
              TextSpan(
                  text: ' from your current location',
                  style: ThemeText.sfMediumFootnote
                      .copyWith(color: ThemeColors.black80)),
            ]),
          ),
          SizedBox(height: 14.0),
          RowCategoryWidget(
            title: 'Hurry. Only 1 room left',
          ),
        ],
      ),
    );
  }
}
