import 'package:flutter/material.dart';
import 'package:localin/model/community/community_detail.dart';
import 'package:localin/presentation/profile/profile_page.dart';
import 'package:localin/provider/community/community_feed_provider.dart';
import 'package:localin/utils/star_display.dart';
import 'package:provider/provider.dart';

import '../../../themes.dart';
import '../pages/community_detail_page.dart';

class CommunityFeedBottomRow extends StatelessWidget {
  final CommunityDetail detail;
  CommunityFeedBottomRow({this.detail});
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<CommunityFeedProvider>(context);
    return Row(
      children: <Widget>[
        StarDisplay(
          value: 4.0,
          size: 20.0,
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
                child: InkWell(
                  onTap: () {
                    provider.joinCommunity(detail?.id);
                  },
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
              ),
            ],
          ),
        )
      ],
    );
  }
}
