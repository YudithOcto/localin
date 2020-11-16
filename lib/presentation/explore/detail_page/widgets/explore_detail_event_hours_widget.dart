import 'package:flutter/material.dart';
import 'package:localin/presentation/explore/detail_page/provider/explore_event_detail_provider.dart';
import 'package:localin/presentation/explore/shared_widgets/event_date_widget.dart';
import 'package:localin/presentation/shared_widgets/explore_operational_hours_page.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

class ExploreDetailEventHoursWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ExploreEventDetailProvider>(context);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Event Date',
            style: ThemeText.sfSemiBoldHeadline,
          ),
          SizedBox(height: 8.0),
          EventDateWidget(
            dateTime:
                '${provider.getFormattedStartDateTime()} - ${provider.getFormattedEndDateTime()}',
          ),
          SizedBox(height: 12.0),
          Visibility(
            visible: false,
            child: InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(
                    ExploreOperationalHoursPage.routeName,
                    arguments: {
                      ExploreOperationalHoursPage.OpeningHours:
                          provider.eventDetail.available
                    });
              },
              child: Container(
                alignment: FractionalOffset.center,
                child: Text(
                  'See all opening hours',
                  textAlign: TextAlign.center,
                  style: ThemeText.sfMediumBody
                      .copyWith(color: ThemeColors.primaryBlue),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
