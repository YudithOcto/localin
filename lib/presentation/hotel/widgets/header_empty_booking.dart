import 'package:flutter/material.dart';
import 'package:localin/utils/constants.dart';

class HeaderEmptyBooking extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: 10.0,
        ),
        Center(
          child: Image.asset(
            'images/empty_room.png',
            scale: 3.0,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(
          height: 40.0,
        ),
        Text(
          'Belum Ada E-tiket dan Voucher Aktif',
          style: kValueStyle.copyWith(fontSize: 16.0),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 0.0),
          child: Text(
            'Temukan di bawah ini inspirasi untuk petualngan anda berikutnya!',
            textAlign: TextAlign.center,
            style: kValueStyle.copyWith(
                fontSize: 14.0,
                color: Colors.black87,
                fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
