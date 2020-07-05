import 'package:flutter/material.dart';
import 'package:localin/analytics/analytic_service.dart';
import 'package:localin/components/base_appbar.dart';
import 'package:localin/components/custom_header_below_base_appbar.dart';
import 'package:localin/presentation/hotel/widgets/header_empty_booking.dart';
import 'package:localin/presentation/hotel/widgets/history_single_card.dart';
import 'package:localin/provider/hotel/booking_history_provider.dart';
import 'package:localin/utils/constants.dart';
import 'package:provider/provider.dart';

import '../../locator.dart';
import '../../themes.dart';

class BookingHistoryPage extends StatefulWidget {
  static const routeName = 'BookingHistoryPage';

  @override
  _BookingHistoryPageState createState() => _BookingHistoryPageState();
}

class _BookingHistoryPageState extends State<BookingHistoryPage> {
  @override
  void initState() {
    locator<AnalyticsService>().setScreenName(name: 'BookingHistoryPage');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        appBar: AppBar(),
      ),
      body: AvailableHistoryContentWidget(),
    );
  }
}

class AvailableHistoryContentWidget extends StatefulWidget {
  @override
  _AvailableHistoryContentWidgetState createState() =>
      _AvailableHistoryContentWidgetState();
}

class _AvailableHistoryContentWidgetState
    extends State<AvailableHistoryContentWidget> {
  final int pageSize = 10;
  bool isInit = true;
  Future getBookingHistory;
  ScrollController _controller;
  bool isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isInit) {
      Provider.of<BookingHistoryProvider>(context).resetParams();
      getBookingHistory = Provider.of<BookingHistoryProvider>(context)
          .getBookingHistoryList()
          .then((value) {
        setState(() {
          isLoading = false;
        });
      });
      _controller = ScrollController()..addListener(_listener);
      isInit = false;
    }
  }

  _listener() {
    final provider =
        Provider.of<BookingHistoryProvider>(context, listen: false);
    if (provider.historyList != null &&
        provider.historyList.isNotEmpty &&
        _controller.offset >= _controller.position.maxScrollExtent &&
        provider.historyList.length < provider.totalPage) {
      provider.getBookingHistoryList();
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _controller,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
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
                            color: ThemeColors.primaryBlue,
                            size: 20.0,
                          ),
                          SizedBox(
                            width: 3.0,
                          ),
                          Text(
                            'Filter',
                            style: kValueStyle.copyWith(
                                color: ThemeColors.primaryBlue),
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
          isLoading
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  ),
                )
              : Consumer<BookingHistoryProvider>(
                  builder: (ctx, provider, child) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: provider.historyList.length + 1 ?? 0,
                      itemBuilder: (context, index) {
                        if (provider.historyList != null &&
                            provider.historyList.isNotEmpty) {
                          if (index == provider.totalPage) {
                            return Container();
                          } else if (index == provider.historyList.length) {
                            return Center(child: CircularProgressIndicator());
                          } else {
                            return HistorySingleCard(
                              detail: provider.historyList[index],
                              onPressed: () {
                                Provider.of<BookingHistoryProvider>(context)
                                    .resetParams();
                                Provider.of<BookingHistoryProvider>(context)
                                    .getBookingHistoryList();
                              },
                            );
                          }
                        } else {
                          return EmptyHistoryContentWidget();
                        }
                      },
                    );
                  },
                ),
        ],
      ),
    );
  }
}

class EmptyHistoryContentWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.15),
        child: HeaderEmptyBooking());
  }
}
