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
            child: Column(
              children: List.generate(
                  detailList != null ? detailList.length : 0, (index) {
                return SingleCommunityCard(
                  total: detailList != null ? detailList.length : 0,
                  detail: detailList[index],
                );
              }),
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
    if (total == 1) {
      /// we have this row if total item just 1
      return InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(CommunityDetailPage.routeName,
              arguments: {CommunityDetailPage.communityModel: detail});
        },
        child: Container(
          margin: EdgeInsets.fromLTRB(0.0, 5.0, 10.0, 15.0),
          child: Column(
            children: <Widget>[
              UpperCommunityCardRow(
                detail: detail,
              ),
              Container(
                width: double.infinity,
                height: 250.0,
                decoration: BoxDecoration(
                    color: Colors.grey,
                    image: detail?.cover != null
                        ? DecorationImage(
                            image: NetworkImage(
                                ImageHelper.addSubFixHttp(detail?.cover)),
                            fit: BoxFit.cover)
                        : null,
                    borderRadius: BorderRadius.circular(12.0)),
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
    } else {
      return Container(
        width: double.infinity,
        height: 300.0,
        margin: EdgeInsets.fromLTRB(0.0, 5.0, 10.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            UpperCommunityCardRow(
              detail: detail,
            ),
            Flexible(
              child: Row(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        image: detail?.cover != null
                            ? DecorationImage(
                                image: NetworkImage(detail?.cover),
                                fit: BoxFit.cover)
                            : null,
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
            CommunityFeedBottomRow(
              detail: detail,
            )
          ],
        ),
      );
    }
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
              detail != null && detail.logoUrl != null
                  ? Image.network(
                      detail?.logoUrl,
                      width: 50.0,
                      height: 50.0,
                    )
                  : Image.asset(
                      'images/community_logo.png',
                      scale: 1.5,
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
            margin: EdgeInsets.only(left: 5.0, right: 10.0, bottom: 10.0),
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
                      '${detail?.categoryName}',
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
                    '${detail?.follower} Orang Mengikuti',
                    textAlign: TextAlign.right,
                    style: kValueStyle.copyWith(
                        fontSize: 10.0, color: Themes.primaryBlue),
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
