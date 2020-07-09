import 'package:flutter/material.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  static const routeName = 'CalendarPage';

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final _calendarController = CalendarController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.black10,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: ThemeColors.black0,
        leading: Icon(
          Icons.arrow_back,
          color: ThemeColors.black80,
        ),
        titleSpacing: 0.0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Book Ticket',
              style: ThemeText.sfMediumHeadline,
            ),
            Text(
              'Select date and total of visitors',
              style: ThemeText.sfMediumFootnote
                  .copyWith(color: ThemeColors.black80),
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 72.0,
        color: ThemeColors.black0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'IDR 267.000',
                    style: ThemeText.sfSemiBoldHeadline
                        .copyWith(color: ThemeColors.orange),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    '2 tickets',
                    style: ThemeText.sfSemiBoldFootnote
                        .copyWith(color: ThemeColors.black60),
                  )
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  color: ThemeColors.primaryBlue,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 20.0),
                  child: Text(
                    'Continue',
                    style: ThemeText.rodinaTitle3
                        .copyWith(color: ThemeColors.black0),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 12.0),
              color: ThemeColors.black0,
              child: TableCalendar(
                startingDayOfWeek: StartingDayOfWeek.monday,
                calendarController: _calendarController,
                daysOfWeekStyle: DaysOfWeekStyle(
                    weekendStyle: ThemeText.sfSemiBoldBody
                        .copyWith(color: ThemeColors.red),
                    weekdayStyle: ThemeText.sfSemiBoldBody
                        .copyWith(color: ThemeColors.black80)),
                calendarStyle: CalendarStyle(
                    highlightToday: false,
                    selectedColor: ThemeColors.primaryBlue,
                    selectedStyle: ThemeText.sfSemiBoldHeadline
                        .copyWith(color: ThemeColors.black0),
                    todayStyle: ThemeText.sfSemiBoldHeadline
                        .copyWith(color: ThemeColors.primaryBlue),
                    outsideStyle: ThemeText.sfSemiBoldHeadline
                        .copyWith(color: ThemeColors.black60),
                    outsideWeekendStyle: ThemeText.sfSemiBoldHeadline
                        .copyWith(color: ThemeColors.black60),
                    weekdayStyle: ThemeText.sfSemiBoldHeadline,
                    weekendStyle: ThemeText.sfSemiBoldHeadline
                        .copyWith(color: ThemeColors.black60)),
                headerStyle: HeaderStyle(
                  titleTextStyle: ThemeText.sfMediumHeadline,
                  formatButtonVisible: false,
                  centerHeaderTitle: true,
                ),
              ),
            ),
            Container(
              color: ThemeColors.black0,
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.symmetric(vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('IDR 89.000', style: ThemeText.sfSemiBoldHeadline),
                      SizedBox(height: 4.0),
                      Text(
                        '/ticket',
                        style: ThemeText.sfSemiBoldFootnote
                            .copyWith(color: ThemeColors.black60),
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        height: 40.0,
                        width: 40.0,
                        decoration: BoxDecoration(
                            color: ThemeColors.black10,
                            borderRadius: BorderRadius.circular(8.0)),
                        child: Icon(
                          Icons.remove,
                          color: ThemeColors.black100,
                        ),
                      ),
                      Container(
                        height: 40.0,
                        width: 52.0,
                        alignment: FractionalOffset.center,
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        decoration: BoxDecoration(
                            border: Border.all(color: ThemeColors.black20),
                            borderRadius: BorderRadius.circular(8.0)),
                        child: Text(
                          '3',
                          textAlign: TextAlign.center,
                          style: ThemeText.sfSemiBoldFootnote,
                        ),
                      ),
                      Container(
                        height: 40.0,
                        width: 40.0,
                        decoration: BoxDecoration(
                            color: ThemeColors.black10,
                            borderRadius: BorderRadius.circular(8.0)),
                        child: Icon(
                          Icons.add,
                          color: ThemeColors.black100,
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
