import 'package:flutter/material.dart';

import '../../../themes.dart';

class RoomDetailCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'RedDoorz Apartment near Summarecon Mall Serpong',
                  style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  'Kelapa Dua kAb. Tangerang',
                  style: TextStyle(fontSize: 11.0, color: Colors.black38),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: <Widget>[
                    blueCard('Guests', '1'),
                    SizedBox(
                      width: 5.0,
                    ),
                    blueCard('Rooms', '1 RedDoors Room'),
                    SizedBox(
                      width: 5.0,
                    ),
                    blueCard('Price', 'Rp 233.750'),
                  ],
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.asset(
              'images/cafe.jpg',
              width: 100.0,
              height: 100.0,
              fit: BoxFit.fill,
            ),
          ),
        ),
      ],
    );
  }

  Widget blueCard(String title, String value) {
    return Container(
      height: 40.0,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
          color: Themes.primaryBlue, borderRadius: BorderRadius.circular(4.0)),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(fontSize: 11.0, color: Colors.white),
            ),
            SizedBox(
              height: 5.0,
            ),
            Text(value,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 11.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }
}
