import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localin/presentation/revamp_hotel/hotel_list_page/hotel_list_page.dart';
import 'package:localin/presentation/transaction/hotel/transaction_hotel_detail_page.dart';
import 'package:localin/provider/auth_provider.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

class HotelSuccessfulPage extends StatelessWidget {
  static const routeName = 'HotelSuccessfulPage';
  static const bookingId = 'BookingId';
  static const localPoint = 'LocalPoint';

  @override
  Widget build(BuildContext context) {
    Provider.of<AuthProvider>(context, listen: false).refreshUserData();
    final routes =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    return Scaffold(
      body: Stack(
        clipBehavior: Clip.none, fit: StackFit.expand,
        children: <Widget>[
          Image.asset(
            'images/overlay.png',
            fit: BoxFit.cover,
          ),
          Positioned(
            top: 46.0,
            right: 26.0,
            child: InkWell(
              onTap: () {
                Navigator.of(context)
                    .popUntil(ModalRoute.withName(HotelListPage.routeName));
              },
              child: Icon(
                Icons.close,
                color: ThemeColors.black0,
              ),
            ),
          ),
          Positioned(
            top: 0.0,
            left: 20.0,
            right: 20.0,
            bottom: 0.0,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SvgPicture.asset('images/payment_successful.svg'),
                SizedBox(
                  height: 33.0,
                ),
                Text(
                  'Payment Successful',
                  textAlign: TextAlign.center,
                  style: ThemeText.rodinaTitle2
                      .copyWith(color: ThemeColors.black0),
                ),
                SizedBox(
                  height: 4.0,
                ),
                Text(
                  'We have received your payment. An email information regarding'
                  ' this payment will be sent to you shortly with your order details.',
                  textAlign: TextAlign.center,
                  style: ThemeText.sfRegularBody
                      .copyWith(color: ThemeColors.black0),
                ),
                Visibility(
                  visible: routes[localPoint] != null,
                  child: Container(
                    width: double.maxFinite,
                    height: 48.0,
                    alignment: FractionalOffset.center,
                    margin:
                        EdgeInsets.symmetric(horizontal: 35.0, vertical: 15.0),
                    decoration: BoxDecoration(
                      color: ThemeColors.red,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Text(
                        'YOU GOT ${routes != null ? routes[localPoint] : 0} LOCAL POIN!',
                        textAlign: TextAlign.center,
                        style: ThemeText.rodinaHeadline
                            .copyWith(color: ThemeColors.black0)),
                  ),
                ),
                InkWell(
                  onTap: () {
                    final route = ModalRoute.of(context).settings.arguments
                        as Map<String, dynamic>;
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        TransactionHotelDetailPage.routeName, (route) => false,
                        arguments: {
                          TransactionHotelDetailPage.bookingId:
                              route[bookingId],
                          TransactionHotelDetailPage.fromSuccessPage: true,
                        });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.0),
                      color: ThemeColors.black0,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 12.0),
                      child: Text(
                        'Back to Home',
                        style: ThemeText.rodinaTitle3
                            .copyWith(color: ThemeColors.primaryBlue),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
