import 'package:flutter/material.dart';
import 'package:localin/utils/constants.dart';

import '../../themes.dart';

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
        InkWell(
          onTap: onPressed,
          child: Container(
            decoration: BoxDecoration(
                color: Themes.primaryBlue,
                borderRadius: BorderRadius.circular(10.0)),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
              child: Text(
                'CONNECT',
                style: Constants.kValueStyle.copyWith(
                    color: Colors.white,
                    fontSize: 12.0,
                    letterSpacing: -.5,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
