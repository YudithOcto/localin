import 'package:flutter/material.dart';
import 'package:localin/presentation/hotel/widgets/booking_information_card.dart';
import 'package:localin/presentation/hotel/widgets/booking_product_detail_card.dart';

import '../../themes.dart';

class SuccessBookingPage extends StatefulWidget {
  static const routeName = '/successBookingPage';
  @override
  _SuccessBookingPageState createState() => _SuccessBookingPageState();
}

class _SuccessBookingPageState extends State<SuccessBookingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Themes.darkBlue,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 5.0,
          backgroundColor: Theme.of(context).canvasColor,
          title: Image.asset(
            'images/app_bar_logo.png',
            width: MediaQuery.of(context).size.width * 0.3,
            height: 50.0,
          ),
        ),
        body: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                BookingInformationCard(),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Icon(
                    Icons.keyboard_backspace,
                    color: Colors.white,
                    size: 40.0,
                  ),
                ),
                Center(
                  child: Image.asset(
                    'images/success_icon.png',
                    scale: 2.0,
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Center(
                  child: Text(
                    'Success! Your stay is confirmed',
                    style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Center(
                  child: Text(
                    'Booking ID: NYDHO123',
                    style: TextStyle(
                        fontSize: 11.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w300),
                  ),
                ),
                CustomRoundedButton(),
                BookingProductDetailCard(),
              ],
            ),
          ),
        ));
  }
}

class CustomRoundedButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 15.0, bottom: 5.0),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8.0)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('Check in time 01:30 PM onwards',
                style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500)),
            Text(
              'Update',
              style: TextStyle(
                  fontSize: 11.0,
                  color: Themes.primaryBlue,
                  fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }
}
