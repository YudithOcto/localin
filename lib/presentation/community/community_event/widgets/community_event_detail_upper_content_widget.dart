import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localin/presentation/community/community_event/provider/community_event_detail_provider.dart';
import 'package:localin/presentation/shared_widgets/subtitle.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:localin/utils/date_helper.dart';
import 'package:provider/provider.dart';

class CommunityEventDetailUpperContentWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CommunityEventDetailProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                  top: 27.0, bottom: 8.0, left: 20.0, right: 20.0),
              child: Subtitle(
                title: 'Event Detail',
              ),
            ),
            Container(
              color: ThemeColors.black0,
              width: double.maxFinite,
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  RowTimeWidget(
                    'Start',
                    date: provider.eventResponse.startDate,
                    time: provider.eventResponse.startTime,
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  RowTimeWidget(
                    'End',
                    date: provider.eventResponse.endDate,
                    time: provider.eventResponse.endTime,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 26.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Description',
                          style: ThemeText.sfMediumBody
                              .copyWith(color: ThemeColors.black80),
                        ),
                        SizedBox(
                          height: 4.0,
                        ),
                        Text(
                          '${provider.eventResponse.description}',
                          style: ThemeText.sfRegularBody,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class RowTimeWidget extends StatelessWidget {
  final DateTime date;
  final String time;
  final String title;
  RowTimeWidget(this.title, {@required this.date, @required this.time});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: ThemeColors.black10,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                title,
                style: ThemeText.sfSemiBoldFootnote,
              ),
            ),
            Row(
              children: <Widget>[
                SvgPicture.asset('images/calendar.svg'),
                SizedBox(
                  width: 13.0,
                ),
                Text(
                  '${DateHelper.formatDate(date: date)},'
                  ' ${time.substring(0, time.length - 3)} WIB',
                  style: ThemeText.sfMediumFootnote,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
