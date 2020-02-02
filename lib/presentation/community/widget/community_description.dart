import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:localin/presentation/community/pages/community_create_event_page.dart';
import 'package:localin/presentation/profile/profile_page.dart';
import 'package:localin/provider/community/community_detail_provider.dart';
import 'package:provider/provider.dart';

import '../../../themes.dart';

class CommunityDescription extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CommunityDetailProvider>(context);
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
            CachedNetworkImage(
              imageUrl: provider?.communityDetail?.logo ?? '',
              imageBuilder: (context, imageProvider) {
                return Container(
                  margin: EdgeInsets.only(left: 10.0, top: 10.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.grey,
                    backgroundImage: imageProvider,
                  ),
                );
              },
              errorWidget: (context, url, child) => Container(
                margin: EdgeInsets.only(left: 10.0, top: 10.0),
                child: CircleAvatar(
                  backgroundColor: Colors.grey,
                ),
              ),
            ),
            SizedBox(
              width: 15.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '${provider?.communityDetail?.name}',
                  style: kValueStyle.copyWith(
                      color: Themes.primaryBlue, fontSize: 20.0),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Visibility(
                      visible: provider?.communityDetail?.address != null,
                      child: Icon(
                        Icons.location_on,
                        color: Themes.primaryBlue,
                        size: 8.0,
                      ),
                    ),
                    Visibility(
                      visible: provider?.communityDetail?.address != null,
                      child: SizedBox(
                        width: 5.0,
                      ),
                    ),
                    Visibility(
                      visible: provider?.communityDetail?.address != null,
                      child: Text(
                        '${provider.communityDetail?.address}',
                        style: kValueStyle.copyWith(
                            fontSize: 10.0, color: Colors.black38),
                      ),
                    ),
                    Visibility(
                      visible: provider?.communityDetail?.address != null,
                      child: SizedBox(
                        width: 5.0,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Themes.primaryBlue,
                          borderRadius: BorderRadius.circular(5.0)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 2.0),
                        child: Text(
                          '${provider?.communityDetail?.categoryName}',
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
                InkWell(
                  onTap: () {
                    provider.setSearchMemberPage(true);
                  },
                  child: Text(
                    '${provider?.communityDetail?.follower} Mengikuti',
                    textAlign: TextAlign.right,
                    style: kValueStyle.copyWith(
                        fontSize: 10.0, color: Themes.primaryBlue),
                  ),
                )
              ],
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(right: 15.0),
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed(CommunityCreateEventPage.routeName);
//                    Navigator.of(context).pushNamed(
//                        CommunityCreateEditPage.routeName,
//                        arguments: {
//                          CommunityCreateEditPage.isUpdatePage: true,
//                        });
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
            '${provider?.communityDetail?.description}',
            style: kValueStyle.copyWith(color: Colors.black87, fontSize: 12.0),
          ),
        )
      ],
    );
  }
}
