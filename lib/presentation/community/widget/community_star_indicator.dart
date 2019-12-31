import 'package:flutter/material.dart';
import 'package:localin/model/community/community_detail.dart';
import 'package:localin/presentation/profile/profile_page.dart';
import 'package:localin/utils/star_display.dart';

import '../../../themes.dart';
import '../pages/community_detail_page.dart';

class CommunityStarIndicator extends StatelessWidget {
  final CommunityDetail detail;
  CommunityStarIndicator({this.detail});
  @override
  Widget build(BuildContext context) {
    return Row(
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
              color: Themes.primaryBlue, fontWeight: FontWeight.w500),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed(CommunityDetailPage.routeName,
                      arguments: {CommunityDetailPage.communityModel: detail});
                },
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Themes.primaryBlue),
                      borderRadius: BorderRadius.circular(5.0)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    child: Text(
                      'Kunjungi',
                      style: kValueStyle.copyWith(
                          color: Themes.primaryBlue,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              Visibility(
                visible: !detail.isJoin,
                child: Container(
                  decoration: BoxDecoration(
                      color: Themes.primaryBlue,
                      borderRadius: BorderRadius.circular(5.0)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    child: Text(
                      'Gabung Komunitas',
                      style: kValueStyle.copyWith(
                          color: Colors.white,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
