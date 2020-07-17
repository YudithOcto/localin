import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localin/model/transaction/transaction_explore_detail_response.dart';
import 'package:localin/presentation/shared_widgets/subtitle.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/utils/date_helper.dart';

import '../../../../themes.dart';

class ExploreBookingDetailWidget extends StatelessWidget {
  final Data exploreDetail;
  ExploreBookingDetailWidget({@required this.exploreDetail});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
              top: 24.0, bottom: 8.0, left: 20.0, right: 20.0),
          child: Subtitle(
            title: 'BOOKING DETAIL',
          ),
        ),
        Container(
          width: double.maxFinite,
          color: ThemeColors.black0,
          margin: EdgeInsets.only(top: 4.0),
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Booking ID: ${exploreDetail?.transactionId}',
                style: ThemeText.sfMediumFootnote
                    .copyWith(color: ThemeColors.black80),
              ),
              SizedBox(height: 8.0),
              Text(
                '${exploreDetail?.description}',
                style: ThemeText.rodinaHeadline,
              ),
              SizedBox(height: 12.0),
              Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 18.0, horizontal: 16.0),
                decoration: BoxDecoration(
                  color: ThemeColors.black10,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                      flex: 2,
                      child: Text('Visit Date',
                          style: ThemeText.sfSemiBoldFootnote),
                    ),
                    SizedBox(width: 10.0),
                    Flexible(
                      flex: 8,
                      child: Row(
                        children: <Widget>[
                          SvgPicture.asset('images/calendar.svg'),
                          SizedBox(width: 10.0),
                          Expanded(
                            child: Text(
                              '${getFormattedDateTime(exploreDetail?.event?.startDate)} - ${getFormattedDateTime(exploreDetail?.event?.endDate)}',
                              style: ThemeText.sfMediumFootnote,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 4.0),
              Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 18.0, horizontal: 16.0),
                decoration: BoxDecoration(
                  color: ThemeColors.black10,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Valid for', style: ThemeText.sfSemiBoldFootnote),
                    Text(
                      '${exploreDetail?.invoiceQuantityTotal} visitor(s)',
                      style: ThemeText.sfMediumFootnote,
                    )
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  getFormattedDateTime(DateTime date) {
    if (date == null) return '';
    return DateHelper.formatDate(
        date: date, format: "EEEE, dd MMMM yyyy 'at' hh:mm");
  }
}
