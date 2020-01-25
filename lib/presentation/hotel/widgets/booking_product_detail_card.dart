import 'package:flutter/material.dart';
import 'package:localin/model/hotel/booking_detail_response.dart';
import 'package:localin/presentation/hotel/widgets/location_detail_card.dart';
import 'package:localin/presentation/hotel/widgets/room_detail_card.dart';
import 'package:localin/utils/date_helper.dart';

import '../../../themes.dart';

class BookingProductDetailCard extends StatelessWidget {
  final BookingDetailModel detail;
  BookingProductDetailCard({this.detail});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8.0)),
      child: Column(
        children: <Widget>[
          customGreenIcon(),
          SizedBox(
            height: 10.0,
          ),
          customText('Person 1'),
          SizedBox(
            height: 5.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              customText(
                  '${DateHelper.formatFromTimeStampShort(detail?.checkIn)}'),
              SizedBox(
                width: 15.0,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(2.0)),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    '1N',
                    style: TextStyle(fontSize: 10.0),
                  ),
                ),
              ),
              SizedBox(
                width: 15.0,
              ),
              customText(
                  '${DateHelper.formatFromTimeStampShort(detail?.checkOut)}'),
            ],
          ),
          customDivider(),
          RoomDetailCard(detail: detail),
          customDivider(),
          LocationDetailCard(
            detail: detail,
          ),
        ],
      ),
    );
  }

  Widget customDivider() {
    return Container(
      color: Colors.black26,
      width: double.infinity,
      height: 1.0,
      margin: EdgeInsets.symmetric(vertical: 10.0),
    );
  }

  Widget customGreenIcon() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        margin: EdgeInsets.only(top: 5.0),
        decoration: BoxDecoration(
            color: Themes.green, borderRadius: BorderRadius.circular(12.0)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Seleseikan pembayaran anda dalam',
                  style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w600)),
              Text('')
            ],
          ),
        ),
      ),
    );
  }

  Widget customText(String value) {
    return Text(
      value,
      style: TextStyle(
          fontSize: 14.0, fontWeight: FontWeight.w500, color: Colors.black87),
    );
  }
}
