import 'package:flutter/material.dart';
import 'package:localin/model/community/community_detail.dart';
import 'package:localin/presentation/community/pages/community_create_edit_page.dart';
import 'package:localin/presentation/community/pages/community_create_event_page.dart';
import 'package:localin/presentation/community/pages/community_detail_page.dart';
import 'package:localin/presentation/community/pages/community_member_page.dart';
import 'package:localin/presentation/profile/profile_page.dart';

import '../../../themes.dart';

class CommunityDescription extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    CommunityDetail articleModel =
        routeArgs[CommunityDetailPage.communityModel];
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 15.0,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 5.0,
            ),
            InkWell(
              onTap: () {
//                Navigator.of(context)
//                    .pushNamed(CommunityCreateEventPage.routeName);
                Navigator.of(context).pushNamed(CommunityMemberPage.routeName,
                    arguments: {
                      CommunityMemberPage.communityId: articleModel.id
                    });
              },
              child: articleModel?.logoUrl == null
                  ? Image.asset(
                      'images/community_logo.png',
                      height: 50.0,
                      width: 50.0,
                    )
                  : Image.network(
                      articleModel?.logoUrl,
                      height: 50.0,
                      width: 50.0,
                    ),
            ),
            SizedBox(
              width: 15.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '${articleModel?.name}',
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
                          '${articleModel?.categoryName}',
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
                  '${articleModel?.follower} Mengikuti',
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
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                        CommunityCreateEditPage.routeName,
                        arguments: {
                          CommunityCreateEditPage.isUpdatePage: true,
                        });
                  },
                  child: Icon(
                    Icons.settings,
                    color: Themes.primaryBlue,
                  ),
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
            '${articleModel?.description}',
            style: kValueStyle.copyWith(color: Colors.black87, fontSize: 12.0),
          ),
        )
      ],
    );
  }
}
