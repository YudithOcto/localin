import 'package:flutter/material.dart';
import 'package:localin/components/rounded_button_fill.dart';

class RowConnectDana extends StatelessWidget {
  final Function onPressed;

  RowConnectDana({this.onPressed});
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          'images/dana_logo.png',
          scale: 9.0,
        ),
        SizedBox(
          width: 8.0,
        ),
        RoundedButtonFill(
          onPressed: onPressed,
          title: 'CONNECT',
        )
      ],
    );
  }
}
