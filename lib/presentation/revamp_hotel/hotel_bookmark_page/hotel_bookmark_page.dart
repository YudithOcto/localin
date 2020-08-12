import 'package:flutter/material.dart';
import 'package:localin/presentation/revamp_hotel/shared_widgets/hotel_single_row_widget.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';

class HotelBookmarkPage extends StatelessWidget {
  static const routeName = 'HotelBookmarkPage';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.black10,
      appBar: AppBar(
        backgroundColor: ThemeColors.black0,
        titleSpacing: 0.0,
        leading: InkResponse(
          onTap: () {},
          child: Icon(
            Icons.arrow_back,
            color: ThemeColors.black80,
          ),
        ),
        title: Text(
          'Hotel Bookmarked',
          style: ThemeText.sfMediumHeadline,
        ),
      ),
      body: ListView.builder(
        itemCount: 5,
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: HotelSingleRowWidget(),
          );
        },
      ),
    );
  }
}
