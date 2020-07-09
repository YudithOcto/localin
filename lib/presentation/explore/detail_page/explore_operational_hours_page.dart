import 'package:flutter/material.dart';
import 'package:localin/components/custom_app_bar.dart';
import 'package:localin/presentation/explore/shared_widgets/event_date_widget.dart';
import 'package:localin/presentation/shared_widgets/subtitle.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';

class ExploreOperationalHoursPage extends StatelessWidget {
  static const routeName = 'ExploreOperationalHours';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        pageTitle: 'Opening Hours',
        titleStyle:
            ThemeText.sfMediumHeadline.copyWith(color: ThemeColors.black80),
        appBar: AppBar(),
        leadingIcon: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: Icon(
            Icons.arrow_back,
            color: ThemeColors.black80,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: 7 + 2,
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemBuilder: (context, index) {
          if (index == 0) {
            return titleRow('Weekdays');
          } else if (index == 6) {
            return titleRow('Weekend');
          } else {
            return Padding(
              padding: EdgeInsets.only(
                  left: 20.0,
                  right: 20.0,
                  top: index == 1 || index == 7 ? 12.0 : 4.0),
              child: EventDateWidget(),
            );
          }
        },
      ),
    );
  }

  Widget titleRow(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0, left: 20.0),
      child: Subtitle(title: title),
    );
  }
}
