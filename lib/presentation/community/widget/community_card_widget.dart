import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:localin/model/community/community_detail.dart';
import 'package:localin/presentation/community/pages/community_detail_page.dart';
import 'package:localin/presentation/community/widget/community_feed_bottom_row.dart';
import 'package:localin/presentation/profile/profile_page.dart';
import 'package:localin/utils/image_helper.dart';

import '../../../themes.dart';

class CommunityCardWidget extends StatelessWidget {
  final List<CommunityDetail> detailList;

  CommunityCardWidget({this.detailList});
  @override
  Widget build(BuildContext context) {
    return detailList.isNotEmpty
        ? Container(
            margin: EdgeInsets.only(left: 10.0),
            child: ListView.builder(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemCount: detailList.length ?? 0,
              itemBuilder: (context, index) {
                return SingleCommunityCard(
                  total: detailList != null ? detailList.length : 0,
                  detail: detailList[index],
                );
              },
            ),
          )
        : Center(
            child: Container(
              margin: EdgeInsets.only(top: 40.0),
              child: Text('No Community found'),
            ),
          );
  }
}

class SingleCommunityCard extends StatelessWidget {
  final int total;
  final CommunityDetail detail;

  SingleCommunityCard({this.total, this.detail});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(CommunityDetailPage.routeName,
            arguments: {CommunityDetailPage.communityModel: detail});
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(0.0, 5.0, 10.0, 15.0),
        child: ListView(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          children: <Widget>[
            UpperCommunityCardRow(
              detail: detail,
            ),
            CachedNetworkImage(
              imageBuilder: (context, imageProvider) => Container(
                width: double.infinity,
                height: 250.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  image:
                      DecorationImage(image: imageProvider, fit: BoxFit.cover),
                ),
              ),
              imageUrl: ImageHelper.addSubFixHttp(detail?.cover),
              placeholder: (context, url) => Container(
                color: Colors.grey,
                height: 200,
                width: double.infinity,
              ),
              placeholderFadeInDuration: Duration(milliseconds: 500),
              errorWidget: (context, url, error) =>
                  Container(child: Icon(Icons.error)),
            ),
            SizedBox(
              height: 15.0,
            ),
            CommunityFeedBottomRow(
              detail: detail,
            ),
          ],
        ),
      ),
    );
  }
}

class UpperCommunityCardRow extends StatelessWidget {
  final CommunityDetail detail;
  UpperCommunityCardRow({this.detail});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(CommunityDetailPage.routeName,
            arguments: {CommunityDetailPage.communityModel: detail});
      },
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 15.0,
          ),
          Row(
            children: <Widget>[
              CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(detail?.logoUrl,
                    scale: 5.0,
                    errorListener: () => Container(
                          color: Colors.grey,
                        )),
              ),
              SizedBox(
                width: 10.0,
              ),
              Text(
                '${detail?.name}',
                style: kValueStyle.copyWith(
                    fontSize: 18.0, color: Themes.primaryBlue),
              ),
              Visibility(
                visible: false,
                child: Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Icon(Icons.more_vert),
                  ),
                ),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.only(
                top: 10.0, left: 5.0, right: 10.0, bottom: 10.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Visibility(
                  visible: detail?.address != null,
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.location_on,
                        color: Themes.primaryBlue,
                        size: 12.0,
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        '${detail?.address}',
                        style: kValueStyle.copyWith(
                          fontSize: 11.0,
                        ),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                    ],
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
                      '${detail?.categoryName}',
                      style: kValueStyle.copyWith(
                          color: Colors.white,
                          fontSize: 11.0,
                          letterSpacing: -.5,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    '${detail?.follower} Orang Mengikuti',
                    textAlign: TextAlign.right,
                    style: kValueStyle.copyWith(
                        fontSize: 11.0, color: Themes.primaryBlue),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
