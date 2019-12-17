import 'package:flutter/material.dart';
import 'package:localin/presentation/profile/profile_page.dart';

import '../../../themes.dart';

class BookingInformationCard extends StatelessWidget {
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
          child: Image.asset(
            'images/success_icon.png',
            fit: BoxFit.contain,
            height: 30.0,
            width: 20.0,
          ),
        ),
        Positioned(
          left: 0.0,
          top: 30.0,
          right: 0.0,
          child: Column(
            children: <Widget>[
              Text(
                'Pembelian Berhasil',
                textAlign: TextAlign.center,
              ),
              rowInformation('Booking iD', 'NKYF6429'),
              rowInformation('Dibeli', 'Kamis, 02 Jan 2019'),
              rowInformation('Metode Pembayaran', 'BCA'),
              rowInformation('Rincian Harga', 'Rp 233.750'),
              Container(
                width: double.infinity,
                height: 40.0,
                margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                child: RaisedButton(
                  onPressed: () {},
                  elevation: 5.0,
                  color: Themes.greyGainsBoro,
                  child: Text(
                    'Kirim Bukti Pembelian',
                    style: kValueStyle.copyWith(
                        color: Themes.primaryBlue, fontSize: 11.0),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
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
