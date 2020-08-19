import 'package:flutter/material.dart';
import 'package:localin/presentation/revamp_hotel/hotel_list_page/provider/hotel_list_filter_provider.dart';
import 'package:localin/presentation/revamp_hotel/hotel_list_page/provider/hotel_list_provider.dart';
import 'package:localin/provider/location/location_provider.dart';
import 'package:provider/provider.dart';
import 'widgets/hotel_list_builder.dart';

class HotelListPage extends StatelessWidget {
  static const routeName = 'HotelListPage';
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<HotelListProvider>(
          create: (_) => HotelListProvider(
            coordinates: Provider.of<LocationProvider>(context, listen: false)
                .userCoordinates,
          ),
        ),
        ChangeNotifierProvider<HotelListFilterProvider>(
          create: (_) => HotelListFilterProvider(),
        )
      ],
      child: HotelListBuilder(),
    );
  }
}
