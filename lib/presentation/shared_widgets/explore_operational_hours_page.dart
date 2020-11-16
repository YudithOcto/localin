import 'package:flutter/material.dart';
import 'package:localin/components/custom_app_bar.dart';
import 'package:localin/model/explore/explore_available_event_dates_model.dart';
import 'package:localin/presentation/explore/shared_widgets/event_date_widget.dart';
import 'package:localin/presentation/shared_widgets/subtitle.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:localin/utils/date_helper.dart';

class ExploreOperationalHoursPage extends StatelessWidget {
  static const routeName = 'ExploreOperationalHours';
  static const OpeningHours = 'OpeningHours';

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    List<ExploreAvailableEventDatesDetail> list = routeArgs[OpeningHours];
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
        itemCount: list.length,
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(
                left: 20.0,
                right: 20.0,
                top: index == 1 || index == 7 ? 12.0 : 4.0),
            child: EventDateWidget(
              dateTime:
                  '${getFormattedStartDateTime(list[index].startSale)} - ${getFormattedStartDateTime(list[index].endSale)}',
            ),
          );
        },
      ),
    );
  }

  getFormattedStartDateTime(DateTime dateTime) {
    if (dateTime == null) return '';
    String date = DateHelper.formatDate(
        date: dateTime, format: "EEEE, dd MMMM yyyy 'at' HH:mm");
    return date;
  }

  Widget titleRow(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0, left: 20.0),
      child: Subtitle(title: title),
    );
  }
}
