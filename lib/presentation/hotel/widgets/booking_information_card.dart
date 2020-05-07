import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:localin/model/hotel/booking_detail_response.dart';
import 'package:localin/utils/constants.dart';
import 'package:localin/utils/date_helper.dart';
import '../../../themes.dart';

class BookingInformationCard extends StatelessWidget {
  final BookingDetailModel detail;

  BookingInformationCard({this.detail});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        Container(
          height: size.height * 0.3,
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0), color: Colors.white),
        ),
        Positioned(
          top: -15.0,
          left: 0.0,
          right: 0.0,
          child: Visibility(
            visible: detail?.status?.contains('confirm booking') ?? false,
            child: Image.asset(
              'images/success_icon.png',
              fit: BoxFit.contain,
              height: 30.0,
              width: 20.0,
            ),
          ),
        ),
        Positioned(
          left: 0.0,
          top: 30.0,
          right: 0.0,
          child: Column(
            children: <Widget>[
              Text(
                '${detail?.status?.contains('confirm booking') ?? '' ? 'Pembelian Berhasil' : detail?.status}',
                textAlign: TextAlign.center,
              ),
              rowInformation('Booking ID', '${detail?.invoiceCode}'),
              rowInformation('Dibeli',
                  '${DateHelper.formatDateBookingDetail(detail?.updatedAt)}'),
              rowInformation('Rincian Harga',
                  '${getFormattedCurrency(detail?.userPrice)}'),
              Visibility(
                visible: false,
                child: Container(
                  width: double.infinity,
                  height: 40.0,
                  margin:
                      EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                  child: RaisedButton(
                    onPressed: () {},
                    elevation: 5.0,
                    color: ThemeColors.greyGainsBoro,
                    child: Text(
                      'Kirim Bukti Pembelian',
                      style: kValueStyle.copyWith(
                          color: ThemeColors.primaryBlue, fontSize: 11.0),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  String getFormattedCurrency(int value) {
    if (value == null) return '';
    if (value == 0) return 'IDR 0';
    final formatter = NumberFormat('#,##0', 'en_US');
    return 'IDR ${formatter.format(value)}';
  }

  Widget rowInformation(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title,
            style: kTitleStyle,
          ),
          Text(
            value,
            style: kValueStyle,
          )
        ],
      ),
    );
  }
}
