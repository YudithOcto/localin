import 'package:flutter/material.dart';
import 'package:localin/utils/constants.dart';

class RoomDetailTitle extends StatelessWidget {
  final String title;

  RoomDetailTitle({@required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
      child: Text(
        title,
        style: kValueStyle.copyWith(fontSize: 16.0),
      ),
    );
  }
}
