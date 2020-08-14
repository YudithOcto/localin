import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localin/model/hotel/hotel_list_base_response.dart';
import 'package:localin/model/hotel/revamp_hotel_list_request.dart';
import 'package:localin/presentation/revamp_hotel/hotel_list_page/provider/hotel_list_search_provider.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

import 'hotel_detail_room_type_list_builder.dart';

class HotelDetailRoomTypePickPage extends StatelessWidget {
  static const routeName = 'HotelDetailRoomTypePickPage';
  static const sortingRequest = 'SortingRequest';
  static const hotelDetail = 'HotelDetail';

  @override
  Widget build(BuildContext context) {
    final routes =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    HotelDetailEntity detail = routes[hotelDetail];
    RevampHotelListRequest request = routes[sortingRequest];
    return ChangeNotifierProvider<HotelListSearchProvider>(
      create: (_) => HotelListSearchProvider(request: request, detail: detail),
      child: Scaffold(
        backgroundColor: ThemeColors.black10,
        appBar: AppBar(
          elevation: 2,
          backgroundColor: ThemeColors.black0,
          leading: InkResponse(
            highlightColor: ThemeColors.primaryBlue,
            onTap: () {},
            child: Icon(Icons.arrow_back, color: ThemeColors.black80),
          ),
          titleSpacing: 0.0,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '${detail.hotelName}',
                style: ThemeText.sfMediumHeadline,
              ),
              Text(
                  '${detail.shortAddress} • ${detail.distance} from your location',
                  style: ThemeText.sfMediumCaption)
            ],
          ),
          actions: <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 20.0),
              child: SvgPicture.asset('images/bookmark_outline.svg'),
            ),
          ],
        ),
        body: HotelDetailRoomTypeListBuilder(),
      ),
    );
  }
}
