import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:localin/provider/hotel/search_hotel_provider.dart';
import 'package:localin/themes.dart';
import 'package:localin/utils/date_helper.dart';
import 'package:provider/provider.dart';
import 'package:localin/utils/custom_date_range_picker.dart' as dtf;

class ButtonDateWidget extends StatelessWidget {
  final bool isCheckInDate;
  ButtonDateWidget({@required this.isCheckInDate});

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchHotelProvider>(
      builder: (context, searchProvider, child) {
        return InkWell(
          onTap: () async {
            final List<DateTime> pick = await dtf.showDatePicker(
                context: context,
                initialFirstDate: searchProvider.selectedCheckIn,
                initialLastDate: searchProvider.selectedCheckOut,
                firstDate: new DateTime(DateTime.now().year,
                    DateTime.now().month, DateTime.now().day),
                lastDate: new DateTime(2025));
            if (pick != null && pick.length == 2) {
              searchProvider.setSelectedDate(pick[0], pick[1]);
            }
          },
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: ThemeColors.dimGrey)),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 4.0),
              child: AutoSizeText(
                '${DateHelper.formatDateRangeToString(isCheckInDate ? searchProvider.selectedCheckIn : searchProvider.selectedCheckOut)}',
                minFontSize: 7.0,
                maxFontSize: 14.0,
                maxLines: 1,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: ThemeColors.primaryBlue),
              ),
            ),
          ),
        );
      },
    );
  }
}
