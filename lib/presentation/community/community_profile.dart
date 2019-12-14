import 'package:flutter/material.dart';
import 'package:localin/components/rounded_button_fill.dart';
import 'package:localin/presentation/community/widget/community_profile_form_input.dart';
import 'package:localin/presentation/profile/profile_page.dart';
import 'package:localin/themes.dart';
import 'package:localin/utils/constants.dart';
import 'package:localin/utils/star_display.dart';

class CommunityProfile extends StatefulWidget {
  static const routeName = '/communityProfile';

  @override
  _CommunityProfileState createState() => _CommunityProfileState();
}

class _CommunityProfileState extends State<CommunityProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.3,
                  color: Colors.grey,
                ),
                Positioned(
                  left: 20.0,
                  top: 20.0,
                  child: SafeArea(
                    child: Icon(
                      Icons.keyboard_backspace,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
            CommunityDescription(),
            Visibility(
              visible: true,
              child: Container(
                margin: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
                child: Row(
                  children: <Widget>[
                    StarDisplay(
                      value: 4.0,
                      size: 25.0,
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Text(
                      '4.5',
                      textAlign: TextAlign.center,
                      style: kValueStyle.copyWith(
                          color: Themes.primaryBlue,
                          fontWeight: FontWeight.w500),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: RoundedButtonFill(
                          onPressed: () {},
                          title: 'Gabung Komunitas',
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            CommunityFormInput(isVisible: true),
            SizedBox(
              height: 40.0,
              child: Divider(
                indent: 15.0,
                endIndent: 15.0,
                color: Colors.black54,
              ),
            ),
            Column(
              children: List.generate(2, (index) {
                return SingleCardComment(index: index);
              }),
            )
          ],
        ),
      ),
    );
  }
}

class SingleCardComment extends StatelessWidget {
  final int index;
  SingleCardComment({this.index});
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
            Constants.kRandomWords,
            style: kValueStyle.copyWith(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
                fontSize: 12.0),
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            Constants.kRandomWords,
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
                        'Koemntari',
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

class CommunityDescription extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'images/community_logo.png',
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'IT Community',
                  style: kValueStyle.copyWith(
                      color: Themes.primaryBlue, fontSize: 20.0),
                ),
                Row(
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
                          fontSize: 10.0, color: Colors.black38),
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
                          style: kValueStyle.copyWith(
                              color: Colors.white,
                              fontSize: 8.0,
                              letterSpacing: -.5,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 3.0,
                ),
                Text(
                  '3980 Mengikuti',
                  textAlign: TextAlign.right,
                  style: kValueStyle.copyWith(
                      fontSize: 10.0, color: Themes.primaryBlue),
                )
              ],
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(right: 15.0),
                alignment: Alignment.centerRight,
                child: Icon(
                  Icons.settings,
                  color: Themes.primaryBlue,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 4.0),
          child: Text(
            'Deskripsi',
            style: kValueStyle.copyWith(fontSize: 12.0, color: Colors.black45),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 4.0),
          child: Text(
            kRandomWords,
            style: kValueStyle.copyWith(color: Colors.black87, fontSize: 12.0),
          ),
        )
      ],
    );
  }
}
