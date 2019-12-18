import 'package:flutter/material.dart';
import 'package:localin/presentation/booking/widgets/room_detail_title.dart';
import 'package:localin/utils/constants.dart';

class RoomDescription extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RoomDetailTitle(
          title: 'Property Description',
        ),
        Container(
          margin: EdgeInsets.only(left: 5.0, right: 5.0),
          child: Text(
            kLargeRandomWords.substring(0, 800),
            style: TextStyle(
                fontSize: 12.0,
                color: Color(0xFF696969),
                fontWeight: FontWeight.w500),
          ),
        ),
        Container(
          color: Colors.black38,
          height: 1,
          width: double.infinity,
          margin: EdgeInsets.only(top: 15.0, bottom: 5.0),
        ),
      ],
    );
  }
}
