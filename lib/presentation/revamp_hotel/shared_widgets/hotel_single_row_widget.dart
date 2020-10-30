import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localin/components/custom_image_only_radius.dart';
import 'package:localin/model/hotel/hotel_list_base_response.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:localin/utils/number_helper.dart';

class HotelSingleRowWidget extends StatelessWidget {
  final VoidCallback onTapBookmark;
  final HotelDetailEntity hotelDetail;
  final VoidCallback onRoomTypeClick;
  HotelSingleRowWidget(
      {this.onTapBookmark, this.hotelDetail, this.onRoomTypeClick});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
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
                imageUrl: hotelDetail.image ?? '',
                width: double.maxFinite,
                placeHolderColor: ThemeColors.black60,
                topLeft: 8.0,
                topRight: 8.0,
              ),
              Container(
                width: double.maxFinite,
                height: 188.0,
                decoration: BoxDecoration(
                    color: ThemeColors.black100.withOpacity(0.4),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      topRight: Radius.circular(8.0),
                    )),
              ),
              Positioned(
                top: 12.0,
                right: 12.0,
                child: InkWell(
                  highlightColor: ThemeColors.primaryBlue,
                  onTap: onTapBookmark,
                  child: SvgPicture.asset(
                      'images/${hotelDetail.isBookmark ? 'restaurant_bookmark_active' : 'restaurant_bookmark_not_active'}.svg',
                      width: 34.0,
                      height: 34.0),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.only(
                top: 12.0, bottom: 2.0, left: 15.0, right: 15.0),
            child:
                Text('${hotelDetail.hotelName}', style: ThemeText.rodinaTitle3),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: '${hotelDetail.shortAddress}',
                  style: ThemeText.sfMediumFootnote
                      .copyWith(color: ThemeColors.black80),
                ),
                TextSpan(
                    text: ' • ',
                    style: ThemeText.sfMediumFootnote
                        .copyWith(color: ThemeColors.black80)),
                TextSpan(
                    text: '${hotelDetail.distance}',
                    style: ThemeText.sfMediumFootnote
                        .copyWith(color: ThemeColors.primaryBlue)),
                TextSpan(
                    text: ' from your current location',
                    style: ThemeText.sfMediumFootnote
                        .copyWith(color: ThemeColors.black80)),
              ]),
            ),
          ),
          Visibility(
            visible: hotelDetail.roomAvailability.isNotNullNorNotEmpty,
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 8.0, bottom: 1.0, left: 15.0, right: 15.0),
              child: Text(
                  '${hotelDetail.roomAvailability.isNotNullNorNotEmpty ? hotelDetail.roomAvailability.first.categoryName.toUpperCase() : ''}',
                  style: ThemeText.sfMediumFootnote
                      .copyWith(color: ThemeColors.black80)),
            ),
          ),
          Visibility(
            visible: hotelDetail.roomAvailability.isNotNullNorNotEmpty,
            child: Container(
              margin: EdgeInsets.only(bottom: 18.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 8),
                    child: Text(
                      '${hotelDetail.roomAvailability.isNotNullNorNotEmpty ? getFormattedCurrency(hotelDetail.roomAvailability.first.pricePerNight.oneNight) : ''}',
                      style: ThemeText.rodinaTitle3
                          .copyWith(color: ThemeColors.orange),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8, top: 2.0),
                    child: Text(
                      '${hotelDetail.roomAvailability.isNotNullNorNotEmpty ? getFormattedCurrency(increasePriceCalculation(hotelDetail.roomAvailability.first.sellingAmount)) : ''}',
                      style: ThemeText.sfRegularBody.copyWith(
                          color: ThemeColors.black80,
                          decoration: TextDecoration.lineThrough),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: Visibility(
                      visible:
                          hotelDetail.roomAvailability.isNotNullNorNotEmpty,
                      child: Text(
                        '/ per room per night',
                        style: ThemeText.sfMediumCaption
                            .copyWith(color: ThemeColors.brandBlack),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: !hotelDetail.roomAvailability.isNotNullNorNotEmpty,
            child: Container(
              margin: const EdgeInsets.only(
                  top: 10.0, bottom: 24.0, left: 15.0, right: 20.0),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: ThemeColors.black60,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                'Room Not Available For this Date',
                style: ThemeText.rodinaFootnote
                    .copyWith(color: ThemeColors.black0),
              ),
            ),
          ),
          Visibility(
            visible: hotelDetail.roomAvailability.isNotNullNorNotEmpty &&
                hotelDetail.roomAvailability.length > 1,
            child: InkResponse(
              onTap: onRoomTypeClick,
              highlightColor: ThemeColors.primaryBlue,
              child: Container(
                margin: const EdgeInsets.only(
                    bottom: 18.0, left: 15.0, right: 20.0),
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Explore ${hotelDetail.roomAvailability.length - 1} more room types',
                      style: ThemeText.sfMediumBody
                          .copyWith(color: ThemeColors.primaryBlue),
                    ),
                    Icon(Icons.keyboard_arrow_down,
                        color: ThemeColors.primaryBlue)
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

extension on List {
  bool get isNotNullNorNotEmpty {
    return this != null && this.isNotEmpty;
  }
}
