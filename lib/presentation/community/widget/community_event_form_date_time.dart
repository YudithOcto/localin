import 'package:flutter/material.dart';
import 'package:localin/utils/custom_date_range_picker.dart' as dtf;
import 'package:localin/utils/date_helper.dart';

import '../../../themes.dart';

class CommunityEventFormDateTime extends StatefulWidget {
  @override
  _CommunityEventFormDateTimeState createState() =>
      _CommunityEventFormDateTimeState();
}

class _CommunityEventFormDateTimeState
    extends State<CommunityEventFormDateTime> {
  TimeOfDay beginningEventTime = TimeOfDay.now();
  TimeOfDay endEventTime = TimeOfDay.now();
  DateTime dateTime = DateTime.now();
  DateTime selectedBeginningEvent = DateTime.now();
  DateTime selectedEndEvent = DateTime.now().add(Duration(days: 1));
  @override
  Widget build(BuildContext context) {
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
                      initialFirstDate: DateTime.now(),
                      initialLastDate: DateTime.now().add(Duration(days: 1)),
                      firstDate: new DateTime(DateTime.now().year,
                          DateTime.now().month, DateTime.now().day),
                      lastDate: new DateTime(2025));
                  if (pick != null && pick.length == 2) {
                    setState(() {
                      selectedBeginningEvent = pick[0];
                      selectedEndEvent = pick[1];
                    });
                  }
                },
                color: Themes.primaryBlue,
                child: Text(
                  DateHelper.formatDateRangeToString(selectedBeginningEvent),
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
                  selectBeginningTime();
                },
                color: Themes.primaryBlue,
                child: Text(
                  formattedTime(beginningEventTime),
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
                      initialFirstDate: DateTime.now(),
                      initialLastDate: DateTime.now().add(Duration(days: 1)),
                      firstDate: new DateTime(DateTime.now().year,
                          DateTime.now().month, DateTime.now().day),
                      lastDate: new DateTime(2025));
                  if (pick != null && pick.length == 2) {
                    setState(() {
                      selectedBeginningEvent = pick[0];
                      selectedEndEvent = pick[1];
                    });
                  }
                },
                color: Themes.primaryBlue,
                child: Text(
                  DateHelper.formatDateRangeToString(selectedEndEvent),
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
                  selectEndTime();
                },
                color: Themes.primaryBlue,
                child: Text(
                  formattedTime(endEventTime),
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

  String formattedTime(TimeOfDay timeOfDay) {
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final String formattedTimeOfDay = localizations.formatTimeOfDay(timeOfDay);
    return formattedTimeOfDay;
  }

  Future<Null> selectBeginningTime() async {
    var picked =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());

    if (picked != null) {
      setState(() {
        beginningEventTime = picked;
      });
    }
  }

  Future<Null> selectEndTime() async {
    var picked =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());

    if (picked != null) {
      setState(() {
        endEventTime = picked;
      });
    }
  }
}
