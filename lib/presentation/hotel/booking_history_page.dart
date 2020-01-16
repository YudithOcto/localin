import 'package:flutter/material.dart';
import 'package:localin/components/base_appbar.dart';
import 'package:localin/components/custom_header_below_base_appbar.dart';
import 'package:localin/presentation/hotel/widgets/header_empty_booking.dart';
import 'package:localin/presentation/hotel/widgets/history_single_card.dart';
import 'package:localin/presentation/home/widget/home_content_default.dart';
import 'package:localin/presentation/profile/profile_page.dart';

import '../../themes.dart';

class BookingHistoryPage extends StatefulWidget {
  static const routeName = '/bookingHistoryPage';

  const BookingHistoryPage({Key key}) : super(key: key);

  @override
  _BookingHistoryPageState createState() => _BookingHistoryPageState();
}

class _BookingHistoryPageState extends State<BookingHistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        appBar: AppBar(),
      ),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: EmptyHistoryContentWidget(),
      ),
    );
  }
}

class AvailableHistoryContentWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CustomHeaderBelowAppBar(
          title: 'Pemesanan',
        ),
        Material(
          elevation: 10.0,
          color: Colors.white,
          child: Container(
            width: double.infinity,
            height: 50.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    '90 Hari Terakhir',
                    style: kValueStyle,
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Icon(
                        Icons.filter_list,
                        color: Themes.primaryBlue,
                        size: 20.0,
                      ),
                      SizedBox(
                        width: 3.0,
                      ),
                      Text(
                        'Filter',
                        style: kValueStyle.copyWith(color: Themes.primaryBlue),
                      ),
                      SizedBox(
                        width: 15.0,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
          child: Text(
            'Oktober 2019',
            style: kValueStyle.copyWith(fontSize: 20.0),
          ),
        ),
        Column(
          children: List.generate(5, (index) {
            return HistorySingleCard();
          }),
        )
      ],
    );
  }
}

class EmptyHistoryContentWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CustomHeaderBelowAppBar(
          title: 'Pemesanan',
        ),
        HeaderEmptyBooking(),
        HomeContentDefault(),
      ],
    );
  }
}
