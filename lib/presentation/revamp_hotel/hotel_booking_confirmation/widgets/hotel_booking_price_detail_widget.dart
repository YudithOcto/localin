import 'package:flutter/material.dart';
import 'package:localin/model/hotel/revamp_hotel_list_request.dart';
import 'package:localin/model/hotel/room_availability.dart';
import 'package:localin/presentation/news/widgets/comments/parent_comment_card.dart';
import 'package:localin/themes.dart';
import 'package:localin/utils/number_helper.dart';
import '../../../../text_themes.dart';

class HotelBookingPriceDetailWidget extends StatelessWidget {
  final RevampHotelListRequest request;
  final RoomAvailability roomAvailability;
  HotelBookingPriceDetailWidget({this.request, this.roomAvailability});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ThemeColors.black0,
      width: double.maxFinite,
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 20.0),
          SinglePriceDetailRow(
            title: '(${request.totalRooms}) ${roomAvailability.categoryName}',
            value: '${getFormattedCurrency(roomAvailability.sellingAmount)}',
          ),
          SinglePriceDetailRow(
            title: 'Admin Fee',
            value: 'Free',
          ),
          SinglePriceDetailRow(
            title: 'Total',
            value: '${getFormattedCurrency(roomAvailability.sellingAmount)}',
          ),
        ],
      ),
    );
  }
}

class SinglePriceDetailRow extends StatelessWidget {
  final String title;
  final String value;
  SinglePriceDetailRow({this.title, this.value});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              '$title',
              style: ThemeText.sfMediumHeadline,
            ),
            Text(
              '$value',
              style: ThemeText.sfMediumBody.copyWith(color: ThemeColors.orange),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: DashedLine(
            color: ThemeColors.black20,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
