import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:localin/model/hotel/booking_detail.dart';
import 'package:localin/model/hotel/booking_history_base_response.dart';
import 'package:localin/presentation/hotel/booking_detail_page.dart';
import 'package:localin/presentation/profile/profile_page.dart';

import '../../../themes.dart';

class HistorySingleCard extends StatelessWidget {
  final BookingDetail detail;

  HistorySingleCard({this.detail});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(BookingDetailPage.routeName,
            arguments: {BookingDetailPage.bookingId: detail?.bookingId});
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 5.0,
          color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: 'No. Pesanan:\t',
                        style: kTitleStyle,
                      ),
                      TextSpan(
                          text: '${detail?.invoiceCode}',
                          style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w600,
                              color: Themes.primaryBlue)),
                    ],
                  ),
                ),
              ),
              Container(
                color: Themes.greyGainsBoro,
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        Icons.hotel,
                        color: Themes.primaryBlue,
                      ),
                      widthDivider(),
                      Expanded(
                        child: Text(
                          '${detail?.name}',
                          style: kValueStyle,
                        ),
                      ),
                      widthDivider(),
                      Text(
                        '${detail?.state}',
                        style: kValueStyle,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      '${detail?.status}',
                      style: kTitleStyle.copyWith(
                          color: detail?.status == 'confirm booking'
                              ? Themes.green
                              : Themes.red,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '${getFormattedCurrency(detail?.userPrice)}',
                      style: kValueStyle.copyWith(color: Themes.primaryBlue),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  String getFormattedCurrency(int value) {
    if (value == null) return '';
    if (value == 0) return 'IDR 0';
    final formatter = NumberFormat();
    return 'IDR ${formatter.format(value)}';
  }

  Widget widthDivider() {
    return SizedBox(
      width: 10.0,
    );
  }
}
