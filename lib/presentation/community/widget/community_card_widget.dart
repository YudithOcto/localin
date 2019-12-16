import 'package:flutter/material.dart';
import 'package:localin/presentation/community/community_profile.dart';
import 'package:localin/presentation/community/widget/community_star_indicator.dart';
import 'package:localin/presentation/profile/profile_page.dart';
import 'package:localin/utils/star_display.dart';

import '../../../themes.dart';

class CommunityCardWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10.0),
      child: Column(
        children: List.generate(3, (index) {
          return SingleCommunityCard(
            total: 2,
          );
        }),
      ),
    );
  }
}

class SingleCommunityCard extends StatelessWidget {
  final int total;

  SingleCommunityCard({this.total});
  @override
  Widget build(BuildContext context) {
    if (total == 1) {
      /// we have this row if total item just 1
      return InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(CommunityProfile.routeName);
        },
        child: Container(
          margin: EdgeInsets.fromLTRB(0.0, 5.0, 10.0, 15.0),
          child: Column(
            children: <Widget>[
              UpperCommunityCardRow(),
              Container(
                width: double.infinity,
                height: 250.0,
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(12.0)),
              ),
              SizedBox(
                height: 15.0,
              ),
              CommunityStarIndicator(),
            ],
          ),
        ),
      );
    } else {
      return InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(CommunityProfile.routeName);
        },
        child: Container(
          width: double.infinity,
          height: 300.0,
          margin: EdgeInsets.fromLTRB(0.0, 5.0, 10.0, 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              UpperCommunityCardRow(),
              Flexible(
                child: Row(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(12.0)),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(12.0)),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(12.0)),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              CommunityStarIndicator()
            ],
          ),
        ),
      );
    }
  }
}

class UpperCommunityCardRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 15.0,
        ),
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
          margin: EdgeInsets.only(left: 5.0, right: 10.0, bottom: 5.0),
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
                    style: kValueStyle.copyWith(
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
      ],
    );
  }
}
