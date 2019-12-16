import 'package:flutter/material.dart';
import 'package:localin/presentation/profile/profile_page.dart';
import 'package:localin/utils/constants.dart';

import '../../../themes.dart';

class CommunitySingleCard extends StatelessWidget {
  final int index;
  CommunitySingleCard({this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 10.0),
      width: MediaQuery.of(context).size.width * 0.7,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Image.asset(
                'images/community_logo.png',
                scale: 1.5,
              ),
              Text(
                'IT Community',
                style: kValueStyle.copyWith(
                    fontSize: 18.0, color: Themes.primaryBlue),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Icon(Icons.more_vert),
                ),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.only(left: 15.0, right: 10.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Icon(
                  Icons.location_on,
                  color: Themes.primaryBlue,
                  size: 8.0,
                ),
                SizedBox(
                  width: 5.0,
                ),
                Text(
                  'Kebon Nanas, Kota Tangerang',
                  style: kValueStyle.copyWith(
                    fontSize: 8.0,
                  ),
                ),
                SizedBox(
                  width: 5.0,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Themes.primaryBlue,
                      borderRadius: BorderRadius.circular(5.0)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 2.0),
                    child: Text(
                      'IT',
                      style: Constants.kValueStyle.copyWith(
                          color: Colors.white,
                          fontSize: 8.0,
                          letterSpacing: -.5,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    '3980 Mengikuti',
                    textAlign: TextAlign.right,
                    style: kValueStyle.copyWith(
                        fontSize: 8.0, color: Themes.primaryBlue),
                  ),
                )
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: 200.0,
            margin: EdgeInsets.only(top: 10.0),
            decoration: BoxDecoration(
                color: Colors.grey, borderRadius: BorderRadius.circular(8.0)),
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Icon(
                Icons.star,
                color: Themes.primaryBlue,
              ),
              SizedBox(
                width: 5.0,
              ),
              Text(
                '4.8',
                style: kValueStyle.copyWith(
                    fontSize: 15.0, color: Themes.primaryBlue),
              ),
              SizedBox(
                width: 10.0,
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Themes.primaryBlue),
                    borderRadius: BorderRadius.circular(5.0)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  child: Text(
                    'Kunjungi',
                    style: Constants.kValueStyle.copyWith(
                        color: Themes.primaryBlue,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Themes.primaryBlue,
                    borderRadius: BorderRadius.circular(5.0)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  child: Text(
                    'Gabung Komunitas',
                    style: Constants.kValueStyle.copyWith(
                        color: Colors.white,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5.0,
          ),
        ],
      ),
    );
  }
}
