import 'package:flutter/material.dart';
import 'package:localin/presentation/revamp_hotel/hotel_detail_page/widgets/hotel_detail_room_type_header.dart';
import 'package:localin/presentation/revamp_hotel/hotel_list_page/provider/hotel_list_search_provider.dart';
import 'package:localin/provider/hotel/hotel_detail_provider.dart';
import 'package:provider/provider.dart';

import 'hotel_detail_room_type_single_row_widget.dart';

class HotelDetailRoomTypeListBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<RoomState>(
        stream:
            Provider.of<HotelListSearchProvider>(context, listen: false).stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              (snapshot.hasData && snapshot.data == RoomState.loading)) {
            return Center(child: CircularProgressIndicator());
          } else {
            return ListView(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              children: <Widget>[
                HotelDetailRoomTypeHeader(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                      Provider.of<HotelListSearchProvider>(context)
                          .roomAvailability
                          .length,
                      (index) => HotelDetailRoomTypeSingleRowWidget(
                            detail:
                                Provider.of<HotelListSearchProvider>(context)
                                    .roomAvailability[index],
                          )),
                )
              ],
            );
          }
        });
  }
}
