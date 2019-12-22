import 'package:flutter/material.dart';
import 'package:localin/presentation/profile/profile_page.dart';

import '../../../themes.dart';

class DanaActiveRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Image.asset(
                'images/dana_logo.png',
                scale: 7.0,
              ),
              SizedBox(
                height: 5.0,
              ),
              Text(
                'Saldo',
                style: kTitleStyle,
              )
            ],
          ),
          SizedBox(
            width: 10.0,
          ),
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: Themes.primaryBlue),
                borderRadius: BorderRadius.circular(10.0)),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 2.0),
              child: Text(
                'AKTIF',
                style: kValueStyle.copyWith(
                    color: Themes.primaryBlue,
                    letterSpacing: -.5,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  '62********9123',
                  style: kValueStyle,
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  'Rp 21.500',
                  style: kValueStyle.copyWith(color: Themes.primaryBlue),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
