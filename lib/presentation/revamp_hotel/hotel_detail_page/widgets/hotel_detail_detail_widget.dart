import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localin/presentation/shared_widgets/subtitle.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:localin/utils/date_helper.dart';
import 'package:readmore/readmore.dart';

class HotelDetailDetailsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                        DateTime.now()
                            .add(Duration(days: 10))
                            .toIso8601String()),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(right: 20.0, left: 20.0, top: 8.0),
                  child: RowEventWidget(
                    title: 'Check-out time',
                    dateTime: DateHelper.formatDateBookingDetailShort(
                        DateTime.now()
                            .add(Duration(milliseconds: 500))
                            .toIso8601String()),
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
                        'A popular budget hotel in Bandung OYO 1945 Hotel Bali Indah remains '
                        'in limelight for multiple reasons. This budget hotel in Bandung,'
                        ' West Java is located at a distance of about 1.6 km from Taman Tegallega.'
                        ' It is located only 1.2 km from the Superindo Piset Mall. A perfect blend of',
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
                        '- Couples are welcome - Guests can check in using any Government issued ID proof',
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
