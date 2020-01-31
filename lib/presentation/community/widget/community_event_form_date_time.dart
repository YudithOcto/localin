import 'package:flutter/material.dart';
import 'package:localin/provider/community/community_event_provider.dart';
import 'package:localin/utils/custom_date_range_picker.dart' as dtf;
import 'package:localin/utils/date_helper.dart';
import 'package:provider/provider.dart';

import '../../../themes.dart';

class CommunityEventFormDateTime extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CommunityEventProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Mulai',
          style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
              color: Colors.black54),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              height: 50.0,
              margin: EdgeInsets.symmetric(vertical: 5.0),
              alignment: Alignment.centerLeft,
              child: RaisedButton(
                elevation: 10.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                onPressed: () async {
                  final List<DateTime> pick = await dtf.showDatePicker(
                      context: context,
                      initialFirstDate: provider.startEventDate,
                      initialLastDate: provider.endEventDate,
                      firstDate: new DateTime(DateTime.now().year,
                          DateTime.now().month, DateTime.now().day),
                      lastDate: new DateTime(2025));
                  if (pick != null && pick.length == 2) {
                    provider.setStartDate(pick[0]);
                    provider.setEndDate(pick[1]);
                  }
                },
                color: Themes.primaryBlue,
                child: Text(
                  DateHelper.formatDateRangeToString(provider.startEventDate),
                  style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
              ),
            ),
            Container(
              height: 50.0,
              width: MediaQuery.of(context).size.width * 0.5,
              margin: EdgeInsets.symmetric(vertical: 5.0),
              alignment: Alignment.centerLeft,
              child: RaisedButton(
                elevation: 10.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                onPressed: () async {
                  selectBeginningTime(provider, context);
                },
                color: Themes.primaryBlue,
                child: Text(
                  formattedTime(provider.startEventTime, context),
                  style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
        Text(
          'Selesei',
          style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
              color: Colors.black54),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              height: 50.0,
              margin: EdgeInsets.symmetric(vertical: 5.0),
              alignment: Alignment.centerLeft,
              child: RaisedButton(
                elevation: 10.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                onPressed: () async {
                  final List<DateTime> pick = await dtf.showDatePicker(
                      context: context,
                      initialFirstDate: provider.startEventDate,
                      initialLastDate: provider.endEventDate,
                      firstDate: new DateTime(DateTime.now().year,
                          DateTime.now().month, DateTime.now().day),
                      lastDate: new DateTime(2025));
                  if (pick != null && pick.length == 2) {
                    provider.setStartDate(pick[0]);
                    provider.setEndDate(pick[1]);
                  }
                },
                color: Themes.primaryBlue,
                child: Text(
                  DateHelper.formatDateRangeToString(provider.endEventDate),
                  style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
              ),
            ),
            Container(
              height: 50.0,
              width: MediaQuery.of(context).size.width * 0.5,
              margin: EdgeInsets.symmetric(vertical: 5.0),
              alignment: Alignment.centerLeft,
              child: RaisedButton(
                elevation: 10.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                onPressed: () async {
                  selectEndTime(provider, context);
                },
                color: Themes.primaryBlue,
                child: Text(
                  formattedTime(provider.endEventTime, context),
                  style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String formattedTime(TimeOfDay timeOfDay, BuildContext context) {
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final String formattedTimeOfDay = localizations.formatTimeOfDay(timeOfDay);
    return formattedTimeOfDay;
  }

  Future<Null> selectBeginningTime(
      CommunityEventProvider provider, BuildContext context) async {
    final picked =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());

    if (picked != null) {
      provider.setStartTime(picked);
    }
  }

  Future<Null> selectEndTime(
      CommunityEventProvider provider, BuildContext context) async {
    final picked =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());

    if (picked != null) {
      if (picked.hour > provider.startEventTime.hour) {
        provider.setEndTime(picked);
      } else {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text('You cannot set time before this'),
            duration: Duration(milliseconds: 200),
            action: SnackBarAction(
              label: 'OK',
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        );
      }
    }
  }
}
