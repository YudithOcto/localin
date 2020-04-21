import 'package:flutter/material.dart';

class EmptyHotelWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 40.0),
      child: Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'images/no_hotel_image.jpeg',
            width: 150.0,
            height: 150.0,
          ),
          Text(
            'Belum Ada Hotel Di Sekitarmu, Kami Akan Segera Menambahkannya Untukmu',
            textAlign: TextAlign.center,
          ),
        ],
      )),
    );
  }
}
