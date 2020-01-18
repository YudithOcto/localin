import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:localin/components/base_appbar.dart';
import 'package:localin/components/custom_header_below_base_appbar.dart';
import 'package:localin/model/hotel/booking_history_base_response.dart';
import 'package:localin/presentation/home/widget/search_hotel_widget.dart';
import 'package:localin/presentation/hotel/widgets/header_empty_booking.dart';
import 'package:localin/presentation/hotel/widgets/history_single_card.dart';
import 'package:localin/presentation/home/widget/home_content_default.dart';
import 'package:localin/presentation/profile/profile_page.dart';
import 'package:localin/provider/hotel/booking_history_provider.dart';
import 'package:provider/provider.dart';

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
        child: AvailableHistoryContentWidget(),
      ),
    );
  }
}

class AvailableHistoryContentWidget extends StatelessWidget {
  final int pageSize = 4;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CustomHeaderBelowAppBar(
          title: 'Pemesanan',
        ),
        Visibility(
          visible: false,
          child: Material(
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
                          style:
                              kValueStyle.copyWith(color: Themes.primaryBlue),
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
        ),
        Visibility(
          visible: false,
          child: Container(
            margin: EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
            child: Text(
              'Oktober 2019',
              style: kValueStyle.copyWith(fontSize: 20.0),
            ),
          ),
        ),
        PagewiseListView<BookingHistoryDetail>(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          pageSize: pageSize,
          itemBuilder: (context, item, index) {
            return HistorySingleCard(
              detail: item,
            );
          },
          errorBuilder: (context, item) {
            return EmptyHistoryContentWidget();
          },
          showRetry: false,
          pageFuture: (pageIndex) {
            return Provider.of<BookingHistoryProvider>(context)
                .getBookingHistory(pageIndex + 1, pageSize);
          },
        )
      ],
    );
  }
}

class EmptyHistoryContentWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = Provider.of<BookingHistoryProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        HeaderEmptyBooking(),
        state.showSearchHotel
            ? SearchHotelWidget(
                isHomePage: false,
              )
            : HomeContentDefault(
                isHomePage: false,
              ),
      ],
    );
  }
}
