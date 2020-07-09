import 'package:flutter/material.dart';
import 'package:localin/presentation/explore/detail_page/explore_operational_hours_page.dart';
import 'package:localin/presentation/explore/shared_widgets/event_date_widget.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';

class ExploreDetailEventHoursWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
          EventDateWidget(),
          SizedBox(height: 12.0),
          InkWell(
            onTap: () {
              Navigator.of(context)
                  .pushNamed(ExploreOperationalHoursPage.routeName);
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
          )
        ],
      ),
    );
  }
}
