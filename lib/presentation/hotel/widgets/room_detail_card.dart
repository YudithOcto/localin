import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:localin/model/hotel/booking_detail_response.dart';

import '../../../themes.dart';

class RoomDetailCard extends StatelessWidget {
  final BookingDetailModel detail;
  RoomDetailCard({this.detail});
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '${detail?.name}',
                  style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  '${detail?.state}',
                  style: TextStyle(
                      fontSize: 11.0,
                      color: Colors.black38,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    blueCard('Guests', '${detail?.guestCount}'),
                    Flexible(child: blueCard('Rooms', '${detail?.roomName}')),
                    blueCard(
                        'Price', '${getFormattedCurrency(detail?.userPrice)}'),
                  ],
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CachedNetworkImage(
            imageUrl: '${detail?.hotelImage}',
            imageBuilder: (context, imageProvider) {
              return Container(
                width: 100.0,
                height: 100.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover)),
              );
            },
            errorWidget: (ctx, item, child) => Container(
              height: 100.0,
              width: 100.0,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String getFormattedCurrency(int value) {
    if (value == null) return '';
    if (value == 0) return 'IDR 0';
    final formatter = NumberFormat('#,##0', 'en_US');
    return 'IDR ${formatter.format(value)}';
  }

  Widget blueCard(String title, String value) {
    return Container(
      margin: EdgeInsets.only(left: 5.0, right: 5.0),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
          color: ThemeColors.primaryBlue,
          borderRadius: BorderRadius.circular(4.0)),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(fontSize: 11.0, color: Colors.white),
            ),
            SizedBox(
              height: 5.0,
            ),
            Text(value,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 11.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }
}
