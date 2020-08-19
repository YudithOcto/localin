import 'package:flutter/material.dart';
import 'package:localin/presentation/revamp_hotel/hotel_list_page/provider/hotel_list_provider.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:localin/utils/date_helper.dart';
import 'package:provider/provider.dart';

class AppBarDetailContentWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HotelListProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '${provider.revampHotelListRequest.search ?? 'Hotel Nearby'}',
          style: ThemeText.sfMediumHeadline,
        ),
        Row(
          children: <Widget>[
            Text(
              '${provider.revampHotelListRequest.checkIn.formattedDate} - '
              '${provider.revampHotelListRequest.checkout.formattedDate}, ${provider.revampHotelListRequest.checkout.difference(provider.revampHotelListRequest.checkIn).inDays} Night',
              style: ThemeText.sfMediumCaption,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                height: 12.0,
                width: 1.0,
                color: ThemeColors.black60,
              ),
            ),
            Expanded(
              child: Text(
                ' ${provider.revampHotelListRequest.totalRooms} Room',
                style: ThemeText.sfMediumCaption,
              ),
            )
          ],
        )
      ],
    );
  }
}

extension on DateTime {
  String get formattedDate {
    if (this == null) return '';
    return DateHelper.formatDate(date: this, format: 'd MMM');
  }
}
