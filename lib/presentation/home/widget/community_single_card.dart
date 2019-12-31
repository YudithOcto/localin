import 'package:flutter/material.dart';
import 'package:localin/model/community/community_detail.dart';
import 'package:localin/presentation/community/pages/community_detail_page.dart';
import 'package:localin/presentation/profile/profile_page.dart';
import 'package:localin/utils/constants.dart';
import 'package:localin/utils/image_helper.dart';

import '../../../themes.dart';

class CommunitySingleCard extends StatefulWidget {
  final int index;
  final CommunityDetail model;

  CommunitySingleCard({this.index, this.model});

  @override
  _CommunitySingleCardState createState() => _CommunitySingleCardState();
}

class _CommunitySingleCardState extends State<CommunitySingleCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 10.0),
      width: MediaQuery.of(context).size.width * 0.7,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          InkWell(
            onTap: () async {
              var result = await Navigator.of(context)
                  .pushNamed(CommunityDetailPage.routeName, arguments: {
                CommunityDetailPage.communityModel: widget.model,
              });

              if (result == 'refresh') {
                /// refresh data
                print(widget.index);
              }
            },
            child: Row(
              children: <Widget>[
                widget.model.logoUrl != null
                    ? Image.network(
                        widget.model.logoUrl,
                        width: 50.0,
                        height: 50.0,
                      )
                    : Image.asset(
                        'images/community_logo.png',
                        width: 50.0,
                        height: 50.0,
                      ),
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  '${widget.model.name}',
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
          ),
          Container(
            margin: EdgeInsets.only(bottom: 5.0),
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
                      '${widget.model.categoryName}',
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
                    '${widget.model.follower} follower',
                    textAlign: TextAlign.right,
                    style: kValueStyle.copyWith(
                        fontSize: 8.0, color: Themes.primaryBlue),
                  ),
                )
              ],
            ),
          ),
          widget.model?.cover != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    widget?.model?.cover,
                    width: double.infinity,
                    height: 200.0,
                    fit: BoxFit.cover,
                  ),
                )
              : Container(
                  width: double.infinity,
                  height: 200.0,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(8.0)),
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
              Text(
                '4.8',
                style: kValueStyle.copyWith(
                    fontSize: 15.0, color: Themes.primaryBlue),
              ),
              SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    InkWell(
                      onTap: () async {
                        var result = await Navigator.of(context).pushNamed(
                            CommunityDetailPage.routeName,
                            arguments: {
                              CommunityDetailPage.communityModel: widget.model,
                            });

                        if (result == 'refresh') {
                          ///refresh here
                        }
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
                            style: Constants.kValueStyle.copyWith(
                                color: Themes.primaryBlue,
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Visibility(
                      visible: widget.model.isJoin == false ? true : false,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Themes.primaryBlue,
                            borderRadius: BorderRadius.circular(5.0)),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              widget.model.isJoin = !widget.model.isJoin;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 4.0),
                            child: Text(
                              'Gabung Komunitas',
                              style: Constants.kValueStyle.copyWith(
                                  color: Colors.white,
                                  fontSize: 12.0,
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
          ),
          SizedBox(
            height: 8.0,
          ),
        ],
      ),
    );
  }
}
