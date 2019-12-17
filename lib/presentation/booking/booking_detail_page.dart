import 'package:flutter/material.dart';
import 'package:localin/components/base_appbar.dart';
import 'package:localin/components/custom_header_below_base_appbar.dart';
import 'package:localin/presentation/booking/widgets/booking_information_card.dart';
import 'package:localin/presentation/booking/widgets/booking_product_detail_card.dart';
import 'package:localin/presentation/profile/profile_page.dart';

import '../../themes.dart';

class BookingDetailPage extends StatefulWidget {
  static const routeName = '/bookingDetailPage';
  @override
  _BookingDetailPageState createState() => _BookingDetailPageState();
}

class _BookingDetailPageState extends State<BookingDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Themes.lightGrey,
      appBar: BaseAppBar(
        appBar: AppBar(),
      ),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Column(
          children: <Widget>[
            CustomHeaderBelowAppBar(
              title: 'Detail Pemesanan',
            ),
            Container(
              margin: EdgeInsets.fromLTRB(15.0, 30.0, 15.0, 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  BookingInformationCard(),
                  Padding(
                    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: Text(
                      'Detail Produk',
                      style: kValueStyle.copyWith(
                          fontSize: 20.0, color: Colors.black),
                    ),
                  ),
                  BookingProductDetailCard(),
                  SizedBox(
                    height: 10.0,
                  ),
                  RaisedButton(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side:
                            BorderSide(color: Themes.primaryBlue, width: 2.0)),
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text(
                          'BATALKAN PEMESANAN',
                          style: TextStyle(
                              fontSize: 12.0,
                              color: Themes.primaryBlue,
                              fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
