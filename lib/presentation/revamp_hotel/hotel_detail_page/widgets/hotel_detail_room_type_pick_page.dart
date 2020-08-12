import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localin/presentation/revamp_hotel/hotel_detail_page/widgets/hotel_detail_room_type_header.dart';
import 'package:localin/presentation/revamp_hotel/hotel_detail_page/widgets/hotel_detail_room_type_single_row_widget.dart';
import 'package:localin/presentation/revamp_hotel/hotel_list_page/provider/hotel_list_search_provider.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

class HotelDetailRoomTypePickPage extends StatelessWidget {
  static const routeName = 'HotelDetailRoomTypePickPage';
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HotelListSearchProvider>(
      create: (_) => HotelListSearchProvider(),
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
                'OYO Life 2736 Pondok Klara',
                style: ThemeText.sfMediumHeadline,
              ),
              Text('Bandung, Jawa Barat • 1.5km from your location',
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
        body: ListView(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          children: <Widget>[
            HotelDetailRoomTypeHeader(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                  4, (index) => HotelDetailRoomTypeSingleRowWidget()),
            )
          ],
        ),
      ),
    );
  }
}
