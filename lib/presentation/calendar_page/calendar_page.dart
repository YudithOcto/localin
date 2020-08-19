import 'package:flutter/material.dart';
import 'package:localin/presentation/explore/detail_page/provider/ticket_availability_provider.dart';
import 'package:localin/presentation/calendar_page/providers/calendar_ticket_provider.dart';
import 'package:localin/presentation/explore/book_ticket/book_ticket_list_selection_page.dart';
import 'package:localin/presentation/explore/shared_widgets/row_ticket_selection_quantity_widget.dart';
import 'package:localin/presentation/explore/shared_widgets/subtotal_ticket_bottom_widget.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatelessWidget {
  static const routeName = 'CalendarPage';
  static const defaultDate = 'DefaultDate';
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CalendarTicketProvider>(
          create: (_) => CalendarTicketProvider(),
        )
      ],
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
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    DateTime _dateTime = routeArgs[CalendarPage.defaultDate];
    return Scaffold(
      backgroundColor: ThemeColors.black10,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: ThemeColors.black0,
        leading: InkResponse(
          onTap: () => Navigator.of(context).pop(),
          child: Icon(
            Icons.close,
            color: ThemeColors.black80,
          ),
        ),
        titleSpacing: 0.0,
        title: Text(
          'Check In Date',
          style: ThemeText.sfMediumHeadline,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 18.0),
              color: ThemeColors.black0,
              child: TableCalendar(
                startDay: DateTime.now(),
                onDaySelected: (date, events) async {
                  Navigator.of(context).pop(date);
                },
                initialSelectedDay: _dateTime ?? DateTime.now(),
                startingDayOfWeek: StartingDayOfWeek.monday,
                calendarController: _calendarController,
                daysOfWeekStyle: DaysOfWeekStyle(
                    weekendStyle: ThemeText.sfSemiBoldBody
                        .copyWith(color: ThemeColors.red),
                    weekdayStyle: ThemeText.sfSemiBoldBody
                        .copyWith(color: ThemeColors.black80)),
                calendarStyle: CalendarStyle(
                    highlightToday: false,
                    unavailableStyle: ThemeText.sfSemiBoldHeadline
                        .copyWith(color: ThemeColors.black60),
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
                    weekendStyle: ThemeText.sfSemiBoldHeadline),
                headerStyle: HeaderStyle(
                  titleTextStyle: ThemeText.sfMediumHeadline,
                  formatButtonVisible: false,
                  centerHeaderTitle: true,
                ),
              ),
            ),
            Consumer<CalendarTicketProvider>(
              builder: (context, provider, _) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemCount: provider.listTicket.length,
                  itemBuilder: (context, index) {
                    return RowTicketSelectionQuantityWidget();
                  },
                );
              },
            )
            // RowTicketSelectionQuantityWidget(),
          ],
        ),
      ),
    );
  }
}
