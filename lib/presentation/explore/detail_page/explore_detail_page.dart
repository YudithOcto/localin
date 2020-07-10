import 'package:flutter/material.dart';
import 'package:localin/presentation/calendar_page/calendar_page.dart';
import 'package:localin/presentation/explore/detail_page/widgets/explore_detail_big_images_widget.dart';
import 'package:localin/presentation/explore/detail_page/widgets/explore_detail_description_widget.dart';
import 'package:localin/presentation/explore/detail_page/widgets/explore_detail_event_hours_widget.dart';
import 'package:localin/presentation/explore/detail_page/widgets/explore_detail_location_widget.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';

class ExploreDetailPage extends StatelessWidget {
  static const routeName = 'ExploreDetailPage';
  static const exploreId = 'ExploreID';
  @override
  Widget build(BuildContext context) {
    return ExploreDetailWrapperContent();
  }
}

class ExploreDetailWrapperContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            RichText(
              text: TextSpan(children: <TextSpan>[
                TextSpan(
                    text: 'IDR 89.000',
                    style: ThemeText.rodinaTitle2
                        .copyWith(color: ThemeColors.orange)),
                TextSpan(text: '\t/ticket', style: ThemeText.sfMediumCaption),
              ]),
            ),
            InkWell(
              onTap: () =>
                  Navigator.of(context).pushNamed(CalendarPage.routeName),
              child: Container(
                decoration: BoxDecoration(
                    color: ThemeColors.primaryBlue,
                    borderRadius: BorderRadius.circular(4.0)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 20.0),
                  child: Text(
                    'Buy',
                    style: ThemeText.rodinaTitle3
                        .copyWith(color: ThemeColors.black0),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ExploreDetailBigImagesWidget(),
            ExploreDetailDescriptionWidget(),
            ExploreDetailEventHoursWidget(),
            ExploreDetailLocationWidget(),
          ],
        ),
      ),
    );
  }
}
