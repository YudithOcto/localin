import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../text_themes.dart';
import '../../../../themes.dart';

class TransactionHotelDetailRefundInformation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: ThemeColors.black0,
      width: double.maxFinite,
      margin: const EdgeInsets.only(top: 1.5),
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SvgPicture.asset('images/icon_refund.svg'),
          SizedBox(width: 17.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Request Refund',
                style: ThemeText.sfSemiBoldBody,
              ),
              Text(
                'Want to cancel your booking? Learn more here',
                style: ThemeText.sfMediumFootnote
                    .copyWith(color: ThemeColors.black80),
              )
            ],
          )
        ],
      ),
    );
  }
}
