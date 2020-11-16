import 'package:flutter/material.dart';
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
            dateTime:
                DateHelper.formatDateBookingDetailShort(detail.checkIn.date),
          ),
          SizedBox(height: 4.0),
          RowEventWidget(
            title: 'Check-out',
            dateTime:
                DateHelper.formatDateBookingDetailShort(detail.checkOut.date),
          ),
          SizedBox(height: 4.0),
          RowEventWidget(
            title: 'Duration',
            dateTime:
                '${detail.checkOut.parseDate.difference(detail.checkIn.parseDate).inDays} Night(s)',
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
                SizedBox(height: 15.0),
                Text('Capacity', style: ThemeText.sfSemiBoldFootnote),
                SizedBox(height: 2.0),
                Text('2 guest(s)/room', style: ThemeText.sfMediumBody),
                SizedBox(height: 2.0),
                Text('(a total of ${detail?.guestCount} guests in 1 rooms)',
                    style: ThemeText.sfMediumBody),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

extension on int {
  String get date {
    int getMilliseconds = this * 1000;
    return DateTime.fromMillisecondsSinceEpoch(getMilliseconds)
        .toIso8601String();
  }

  DateTime get parseDate {
    int getMilliseconds = this * 1000;
    return DateTime.fromMillisecondsSinceEpoch(getMilliseconds);
  }
}
