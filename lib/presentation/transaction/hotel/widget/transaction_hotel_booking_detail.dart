import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localin/model/hotel/booking_detail_response.dart';
import 'package:localin/presentation/revamp_hotel/hotel_detail_page/widgets/hotel_detail_detail_widget.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:localin/utils/date_helper.dart';

class TransactionHotelBookingDetail extends StatelessWidget {
  final BookingDetailModel detail;
  TransactionHotelBookingDetail({this.detail});

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
          Text('${detail.name}', style: ThemeText.sfMediumHeadline),
          SizedBox(height: 12.0),
          RowEventWidget(
            title: 'Check-in',
            dateTime: DateHelper.formatDateBookingDetailShort(
                DateTime.fromMillisecondsSinceEpoch(detail.checkIn)
                    .toIso8601String()),
          ),
          SizedBox(height: 4.0),
          RowEventWidget(
            title: 'Check-out',
            dateTime: DateHelper.formatDateBookingDetailShort(
                DateTime.fromMillisecondsSinceEpoch(detail.checkOut)
                    .toIso8601String()),
          ),
          SizedBox(height: 4.0),
          RowEventWidget(
            title: 'Duration',
            dateTime:
                '${DateTime.fromMillisecondsSinceEpoch(detail.checkIn).difference(DateTime.fromMillisecondsSinceEpoch(detail.checkOut)).inDays} Night(s)',
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
                Text('${detail?.roomName} (x1)',
                    style: ThemeText.sfSemiBoldBody),
                SizedBox(height: 2.0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
