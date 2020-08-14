import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localin/presentation/revamp_hotel/hotel_detail_page/provider/hotel_detail_api_provider.dart';
import 'package:localin/presentation/shared_widgets/custom_rating_widget.dart';
import 'package:localin/presentation/shared_widgets/row_category_widget.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

class HotelDetailOverviewWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HotelDetailApiProvider>(context);
    return Container(
      padding: const EdgeInsets.all(20.0),
      color: ThemeColors.black0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('${provider.hotelDetailEntity.hotelName}',
              style: ThemeText.rodinaTitle3),
          SizedBox(height: 2.0),
          RichText(
            text: TextSpan(children: [
              TextSpan(
                text: '${provider.hotelDetailEntity.shortAddress}',
                style: ThemeText.sfMediumFootnote
                    .copyWith(color: ThemeColors.black80),
              ),
              TextSpan(
                  text: ' • ',
                  style: ThemeText.sfMediumFootnote
                      .copyWith(color: ThemeColors.black80)),
              TextSpan(
                  text: '${provider.hotelDetailEntity.distance}',
                  style: ThemeText.sfMediumFootnote
                      .copyWith(color: ThemeColors.primaryBlue)),
              TextSpan(
                  text: ' from your current location',
                  style: ThemeText.sfMediumFootnote
                      .copyWith(color: ThemeColors.black80)),
            ]),
          ),
          SizedBox(height: 14.0),
        ],
      ),
    );
  }
}
