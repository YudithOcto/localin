import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';

class HotelDetailRoomTypePickPage extends StatelessWidget {
  static const routeName = 'HotelDetailRoomTypePickPage';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            color: ThemeColors.black0,
            padding: const EdgeInsets.only(
                left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SvgPicture.asset('images/calendar.svg',
                    width: 25.0, height: 20.0),
                SizedBox(width: 10.0),
                Text('Sat, 23 May 2020', style: ThemeText.sfRegularFootnote),
                SizedBox(width: 16.0),
                SvgPicture.asset('images/icon_time.svg',
                    width: 25.0, height: 20.0),
                SizedBox(width: 6.0),
                Text(
                  '1 Night(s)',
                  style: ThemeText.sfRegularFootnote,
                ),
                SizedBox(width: 20.0),
                SvgPicture.asset('images/door_icon.svg',
                    width: 25.0, height: 20.0),
                SizedBox(width: 8.0),
                Text('1', style: ThemeText.sfRegularFootnote),
                SizedBox(width: 8.0),
                SvgPicture.asset('images/icon_user.svg',
                    width: 25.0, height: 20.0),
                SizedBox(width: 10.0),
                Text(
                  '1',
                  style: ThemeText.sfRegularFootnote,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HotelDetailSingleRoomTypeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
