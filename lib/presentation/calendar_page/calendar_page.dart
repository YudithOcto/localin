import 'package:flutter/material.dart';
import 'package:localin/presentation/calendar_page/calendar_provider.dart';
import 'package:localin/presentation/explore/book_ticket/book_ticket_list_selection_page.dart';
import 'package:localin/presentation/explore/shared_widgets/subtotal_ticket_bottom_widget.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatelessWidget {
  static const routeName = 'CalendarPage';
  static const eventId = 'eventId';

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    return ChangeNotifierProvider<CalendarProvider>(
      create: (_) => CalendarProvider(routeArgs[eventId]),
      child: CalendarContent(),
    );
  }
}

class CalendarContent extends StatefulWidget {
  @override
  _CalendarContentState createState() => _CalendarContentState();
}

class _CalendarContentState extends State<CalendarContent> {
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
      bottomNavigationBar: SubtotalTicketButtonWidget(
        onPressed: () => Navigator.of(context)
            .pushNamed(BookTicketListSelectionPage.routeName),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 12.0),
              color: ThemeColors.black0,
              child: TableCalendar(
                onDaySelected: (date, events) {},
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
            // RowTicketSelectionQuantityWidget(),
          ],
        ),
      ),
    );
  }
}
