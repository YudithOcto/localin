import 'package:flutter/material.dart';
import 'package:localin/presentation/revamp_hotel/hotel_search/provider/hotel_search_provider.dart';
import 'package:localin/presentation/revamp_hotel/hotel_search/widgets/hotel_revamp_search_builder.dart';
import 'package:provider/provider.dart';

class HotelRevampSearchPage extends StatelessWidget {
  static const routeName = 'HotelRevampSearchPage';
  static const hotelRevampRequest = 'HotelRevampRequest';

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<HotelSearchProvider>(
          create: (_) => HotelSearchProvider(),
        )
      ],
      child: HotelRevampSearchBuilder(),
    );
  }
}
