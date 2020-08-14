import 'package:flutter/material.dart';

import 'package:localin/presentation/revamp_hotel/hotel_detail_page/provider/hotel_detail_api_provider.dart';
import 'package:localin/presentation/revamp_hotel/hotel_detail_page/provider/hotel_detail_nestedscroll_provider.dart';
import 'package:localin/presentation/revamp_hotel/hotel_detail_page/widgets/hotel_detail_revamp_builder.dart';

import 'package:provider/provider.dart';

class HotelRevampDetailPage extends StatelessWidget {
  static const routeName = 'HotelRevampDetailPage';
  static const previousSort = 'PreviousSort';
  static const hotelId = 'HotelId';
  static const roomSelected = 'RoomSelected';

  @override
  Widget build(BuildContext context) {
    final routes =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<HotelDetailNestedScrollProvider>(
          create: (_) => HotelDetailNestedScrollProvider(),
        ),
        ChangeNotifierProvider<HotelDetailApiProvider>(
          create: (_) => HotelDetailApiProvider(
              hotelId: routes[hotelId],
              request: routes[previousSort],
              room: routes[roomSelected]),
        ),
      ],
      child: HotelDetailRevampBuilder(),
    );
  }
}
