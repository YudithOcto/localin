import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localin/components/bullet_text.dart';
import 'package:localin/presentation/revamp_hotel/hotel_detail_page/provider/hotel_detail_api_provider.dart';
import 'package:localin/presentation/shared_widgets/subtitle.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:localin/utils/date_helper.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:html/parser.dart' as parser;

class HotelDetailDetailsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final detail = Provider.of<HotelDetailApiProvider>(context);
    return Container(
      margin: EdgeInsets.only(bottom: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 28.0, bottom: 8.0),
            child: Subtitle(
              title: 'Hotel Details',
            ),
          ),
          Container(
            color: ThemeColors.black0,
            width: double.maxFinite,
            padding: const EdgeInsets.only(bottom: 35.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.only(right: 20.0, left: 20.0, top: 16.0),
                  child: RowEventWidget(
                    title: 'Check-in time',
                    dateTime: DateHelper.formatDateBookingDetailShort(
                        detail?.request?.checkIn?.toIso8601String()),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(right: 20.0, left: 20.0, top: 8.0),
                  child: RowEventWidget(
                    title: 'Check-out time',
                    dateTime: DateHelper.formatDateBookingDetailShort(
                        detail?.request?.checkout?.toIso8601String()),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(right: 20.0, left: 20.0, top: 26.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Description',
                        style: ThemeText.sfMediumBody,
                      ),
                      SizedBox(height: 4.0),
                      ReadMoreText(
                        '${parseHtml(detail?.hotelDetailEntity?.description)}',
                        trimLines: 5,
                        colorClickableText: ThemeColors.primaryBlue,
                        trimMode: TrimMode.Line,
                        style: ThemeText.sfRegularBody,
                        trimCollapsedText: '...Read more',
                        trimExpandedText: ' Read less',
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(right: 20.0, left: 20.0, top: 26.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Policy',
                        style: ThemeText.sfMediumBody,
                      ),
                      SizedBox(height: 4.0),
                      ReadMoreText(
                        '${parseHtml(detail.hotelDetailEntity.policies.map((e) => '• ' + e + '\n').join(''))}',
                        trimLines: 3,
                        colorClickableText: ThemeColors.primaryBlue,
                        trimMode: TrimMode.Line,
                        style: ThemeText.sfRegularBody,
                        trimCollapsedText: '...Read more',
                        trimExpandedText: ' Read less',
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  parseHtml(String data) {
    final doc = parser.parse(data);
    return parser.parse(doc.body.text).documentElement.text;
  }

  Widget rowRoomInformation(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 1.0),
      child: Bullet(
        title,
        style: TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.w500,
            color: ThemeColors.dimGrey),
      ),
    );
  }
}

class RowEventWidget extends StatelessWidget {
  final String dateTime;
  final String title;
  RowEventWidget({this.dateTime, this.title});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: ThemeColors.black10,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Text(
              '$title',
              style: ThemeText.sfSemiBoldFootnote,
            ),
          ),
          Row(
            children: <Widget>[
              SvgPicture.asset('images/calendar.svg'),
              SizedBox(width: 9.0),
              Text(
                '$dateTime',
                style: ThemeText.sfMediumFootnote,
              )
            ],
          ),
        ],
      ),
    );
  }
}
