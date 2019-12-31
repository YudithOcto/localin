import 'package:flutter/material.dart';
import 'package:localin/presentation/profile/profile_page.dart';
import 'package:localin/utils/constants.dart';

import '../../../themes.dart';

class CommunityCommentCard extends StatelessWidget {
  final int index;
  CommunityCommentCard({this.index});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                backgroundColor: Colors.grey,
                child: Icon(Icons.person),
              ),
              SizedBox(
                width: 10.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Person 1',
                    style: kValueStyle.copyWith(color: Themes.primaryBlue),
                  ),
                  Text(
                    '4 jan',
                    style: kValueStyle.copyWith(
                        fontSize: 10.0, color: Colors.black26),
                  )
                ],
              )
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            kRandomWords,
            style: kValueStyle.copyWith(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
                fontSize: 12.0),
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            kRandomWords,
            style: kValueStyle.copyWith(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
                fontSize: 12.0),
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            '#ITCommunity #IsengItuSukses',
            style: kValueStyle.copyWith(
                color: Themes.primaryBlue,
                fontWeight: FontWeight.w500,
                fontSize: 12.0),
          ),
          SizedBox(
            height: 10.0,
          ),
          Container(
            height: 150.0,
            width: double.infinity,
            color: Colors.grey,
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    '112 suka',
                    style: kValueStyle.copyWith(
                        fontSize: 12.0, color: Colors.black54),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.thumb_up,
                        color: Themes.primaryBlue,
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        'Sukai',
                        style: kValueStyle.copyWith(
                            color: Themes.primaryBlue, fontSize: 12.0),
                      )
                    ],
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Text(
                    '87 Komentar',
                    style: kValueStyle.copyWith(
                        fontSize: 12.0, color: Colors.black54),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.comment,
                        color: Themes.primaryBlue,
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        'Komentari',
                        style: kValueStyle.copyWith(
                            color: Themes.primaryBlue, fontSize: 12.0),
                      )
                    ],
                  ),
                ],
              )
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Divider(
            color: Colors.black54,
          ),
          SizedBox(
            height: 10.0,
          ),
        ],
      ),
    );
  }
}
