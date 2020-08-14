import 'package:flutter/material.dart';
import 'package:localin/model/hotel/hotel_list_base_response.dart';
import 'package:localin/model/hotel/revamp_hotel_list_request.dart';
import 'package:localin/model/hotel/room_availability.dart';
import 'package:localin/presentation/revamp_hotel/hotel_detail_page/widgets/hotel_detail_detail_widget.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:localin/utils/date_helper.dart';

class HotelBookingBasicDetailWidget extends StatelessWidget {
  final HotelDetailEntity hotelDetail;
  final RoomAvailability roomDetail;
  final RevampHotelListRequest request;
  HotelBookingBasicDetailWidget(
      {this.hotelDetail, this.roomDetail, this.request});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      color: ThemeColors.black0,
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('HOTEL',
              style: ThemeText.sfMediumFootnote
                  .copyWith(color: ThemeColors.black80)),
          Text('${hotelDetail.hotelName}', style: ThemeText.sfMediumHeadline),
          SizedBox(height: 12.0),
          RowEventWidget(
            title: 'Check-in',
            dateTime: DateHelper.formatDateBookingDetailShort(
                request.checkIn.toIso8601String()),
          ),
          SizedBox(height: 4.0),
          RowEventWidget(
            title: 'Check-out',
            dateTime: DateHelper.formatDateBookingDetailShort(
                request.checkout.toIso8601String()),
          ),
          SizedBox(height: 4.0),
          RowEventWidget(
            title: 'Duration',
            dateTime: '${request.totalRooms} Night(s)',
          ),
          Container(
            margin: const EdgeInsets.only(top: 4.0),
            width: double.maxFinite,
            padding:
                const EdgeInsets.symmetric(vertical: 18.0, horizontal: 16.0),
            decoration: BoxDecoration(
              color: ThemeColors.black10,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Room', style: ThemeText.sfSemiBoldFootnote),
                SizedBox(height: 3.0),
                Text('${roomDetail.categoryName} (x${request.totalRooms})',
                    style: ThemeText.sfSemiBoldBody),
                SizedBox(height: 2.0),
                Text(
                  '${hotelDetail.facilities.isEmpty ? '' : hotelDetail.facilities.join(' • ')}',
                  style: ThemeText.sfMediumFootnote
                      .copyWith(color: ThemeColors.black80),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
