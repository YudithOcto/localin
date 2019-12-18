import 'package:flutter/material.dart';
import 'package:localin/components/bullet_text.dart';
import 'package:localin/presentation/booking/widgets/room_detail_title.dart';
import 'package:localin/themes.dart';

class RoomPropertyPolicies extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RoomDetailTitle(
          title: 'Property Policies',
        ),
        rowRoomInformation('Check in from 2pm to 4 am on the next day'),
        rowRoomInformation('Check out before 12 pm'),
        Container(
          color: Colors.black38,
          height: 1,
          width: double.infinity,
          margin: EdgeInsets.only(top: 15.0, bottom: 5.0),
        ),
      ],
    );
  }

  Widget rowRoomInformation(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 1.0),
      child: Bullet(
        title,
        style: TextStyle(
            fontSize: 10.0, fontWeight: FontWeight.w500, color: Themes.dimGrey),
      ),
    );
  }
}
