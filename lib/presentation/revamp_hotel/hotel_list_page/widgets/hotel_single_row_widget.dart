import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localin/components/custom_image_only_radius.dart';
import 'package:localin/presentation/shared_widgets/custom_rating_widget.dart';
import 'package:localin/presentation/shared_widgets/row_category_widget.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';

class HotelSingleRowWidget extends StatelessWidget {
  final VoidCallback onTapBookmark;
  HotelSingleRowWidget({this.onTapBookmark});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: ThemeColors.black0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Stack(
            children: <Widget>[
              CustomImageOnlyRadius(
                height: 188.0,
                imageUrl: 'www.google.com',
                width: double.maxFinite,
                placeHolderColor: ThemeColors.black60,
                topLeft: 8.0,
                topRight: 8.0,
              ),
              Container(
                width: double.maxFinite,
                height: 188.0,
                color: ThemeColors.black100.withOpacity(0.4),
              ),
              Positioned(
                top: 12.0,
                right: 12.0,
                child: InkWell(
                  highlightColor: ThemeColors.primaryBlue,
                  onTap: onTapBookmark,
                  child: SvgPicture.asset(
                      'images/${true ? 'restaurant_bookmark_active' : 'restaurant_bookmark_not_active'}.svg',
                      width: 34.0,
                      height: 34.0),
                ),
              ),
              Positioned(
                bottom: 15.0,
                left: 15.0,
                child: CustomRatingWidget(
                  starRating: '4.5',
                  totalRating: '120',
                ),
              ),
            ],
          ),
          SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.only(
                top: 12.0, bottom: 2.0, left: 15.0, right: 15.0),
            child: Text('OYO Life 2736 Pondok Klara',
                style: ThemeText.rodinaTitle3),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: RichText(
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
          ),
          Padding(
            padding: const EdgeInsets.only(
                top: 8.0, bottom: 1.0, left: 15.0, right: 15.0),
            child: Text('INDONESIA DELUXE SINGLE',
                style: ThemeText.sfMediumFootnote
                    .copyWith(color: ThemeColors.black80)),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 8),
                child: Text(
                  'Rp 250.000',
                  style: ThemeText.rodinaTitle3
                      .copyWith(color: ThemeColors.orange),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(
                  'Rp 416.000',
                  style: ThemeText.sfRegularBody.copyWith(
                      color: ThemeColors.black80,
                      decoration: TextDecoration.lineThrough),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: Text(
                  '/ per room per night',
                  style: ThemeText.sfMediumCaption
                      .copyWith(color: ThemeColors.brandBlack),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 15.0, right: 15.0, top: 7.0, bottom: 19.0),
            child: RowCategoryWidget(
              title: 'Hurry. Only 1 room left',
            ),
          )
        ],
      ),
    );
  }
}
