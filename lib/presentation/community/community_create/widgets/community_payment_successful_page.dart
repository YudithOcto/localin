import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localin/model/community/community_detail.dart';
import 'package:localin/presentation/community/community_create/community_create_page.dart';
import 'package:localin/presentation/community/community_detail/community_detail_page.dart';
import 'package:localin/text_themes.dart';

import '../../../../themes.dart';

class CommunityPaymentSuccessfulPage extends StatelessWidget {
  static const routeName = 'CommunitySuccessfulPage';
  static const communityData = 'communityData';
  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    CommunityDetail detail =
        routeArgs[CommunityPaymentSuccessfulPage.communityData];
    return Scaffold(
      body: Stack(
        overflow: Overflow.visible,
        fit: StackFit.expand,
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
                Navigator.of(context).popUntil(
                    ModalRoute.withName(CommunityCreatePage.routeName));
                Navigator.of(context).pop();
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
                  '${detail.transactionId == null ? 'Registration Successful' : 'Payment Successful'}',
                  textAlign: TextAlign.center,
                  style: ThemeText.rodinaTitle2
                      .copyWith(color: ThemeColors.black0),
                ),
                SizedBox(
                  height: 4.0,
                ),
                Text(
                  '${detail.transactionId == null ? 'We have received your registration' : 'We have received your payment. An email information regarding this payment will be sent to you shortly with your order details.'}',
                  textAlign: TextAlign.center,
                  style: ThemeText.sfRegularBody
                      .copyWith(color: ThemeColors.black0),
                ),
                SizedBox(
                  height: 24.0,
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        CommunityDetailPage.routeName, (route) => false,
                        arguments: {
                          CommunityDetailPage.communityData: detail,
                          CommunityDetailPage.needBackToHome: true,
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
                        'Go To My Community',
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
