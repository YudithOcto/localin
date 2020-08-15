import 'package:flutter/material.dart';
import 'package:localin/components/custom_image_only_radius.dart';
import 'package:localin/model/hotel/room_availability.dart';
import 'package:localin/presentation/revamp_hotel/hotel_booking_confirmation/hotel_booking_confirmation_page.dart';
import 'package:localin/presentation/revamp_hotel/hotel_list_page/provider/hotel_list_search_provider.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:localin/utils/number_helper.dart';
import 'package:provider/provider.dart';

class HotelDetailRoomTypeSingleRowWidget extends StatelessWidget {
  final RoomAvailability detail;
  HotelDetailRoomTypeSingleRowWidget({this.detail});

  @override
  Widget build(BuildContext context) {
    final hotelDetail = Provider.of<HotelListSearchProvider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
      child: Container(
        color: ThemeColors.black0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CustomImageOnlyRadius(
              height: 188.0,
              imageUrl: '${hotelDetail.hotelDetail.image}',
              width: double.maxFinite,
              placeHolderColor: ThemeColors.black60,
              topLeft: 8.0,
              topRight: 8.0,
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 12.0, bottom: 2.0, left: 15.0, right: 15.0),
              child:
                  Text('${detail.categoryName}', style: ThemeText.rodinaTitle3),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(bottom: 2.0, left: 15.0, right: 15.0),
              child: Text(
                '${hotelDetail.hotelDetail.facilities.isNullOrEmpty ? '' : hotelDetail.hotelDetail.facilities.join(' • ')}',
                style: ThemeText.sfMediumFootnote
                    .copyWith(color: ThemeColors.black80),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 8),
                  child: Text(
                    '${getFormattedCurrency(detail.sellingAmount)}',
                    style: ThemeText.rodinaTitle3
                        .copyWith(color: ThemeColors.orange),
                  ),
                ),
                Visibility(
                  visible: hotelDetail.discount > 0,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8, top: 8.0),
                    child: Text(
                      '${getFormattedCurrency(detail.pricePerNight.oneNight - hotelDetail.discount)}',
                      style: ThemeText.sfRegularBody.copyWith(
                          color: ThemeColors.black80,
                          decoration: TextDecoration.lineThrough),
                    ),
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
            InkResponse(
              onTap: () {
                Navigator.of(context).pushNamed(
                    HotelBookingConfirmationPage.routeName,
                    arguments: {
                      HotelBookingConfirmationPage.sortRequest:
                          hotelDetail.requestModel,
                      HotelBookingConfirmationPage.hotelDetail:
                          hotelDetail.hotelDetail,
                      HotelBookingConfirmationPage.roomDetail: detail,
                    });
              },
              child: Container(
                margin: EdgeInsets.only(
                    top: 21.0, left: 15.0, right: 15.0, bottom: 18.0),
                height: 48.0,
                padding:
                    const EdgeInsets.only(bottom: 2.0, left: 15.0, right: 15.0),
                alignment: FractionalOffset.center,
                decoration: BoxDecoration(
                  color: ThemeColors.primaryBlue,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                width: double.maxFinite,
                child: Text('Select',
                    style: ThemeText.rodinaTitle3
                        .copyWith(color: ThemeColors.black0)),
              ),
            )
          ],
        ),
      ),
    );
  }
}

extension on List {
  bool get isNullOrEmpty {
    return this == null || this.isEmpty;
  }
}
