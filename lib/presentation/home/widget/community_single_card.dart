import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:localin/model/community/community_detail.dart';
import 'package:localin/presentation/community/community_detail/community_detail_page.dart';
import 'package:localin/themes.dart';
import 'package:localin/utils/constants.dart';

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
      margin:
          EdgeInsets.only(right: 10.0, left: widget.index == 0 ? 15.0 : 0.0),
      width: MediaQuery.of(context).size.width * 0.7,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          InkWell(
            onTap: () async {
              final result = await Navigator.of(context)
                  .pushNamed(CommunityDetailPage.routeName, arguments: {
                CommunityDetailPage.communitySlug: widget.model.slug,
              });

              if (result == 'refresh') {
                setState(() {
                  widget.model.isJoin = !widget.model.isJoin;
                });
              }
            },
            child: Row(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(60.0),
                  child: CachedNetworkImage(
                    width: 40.0,
                    height: 40.0,
                    imageUrl: widget.model?.logoUrl,
                    fit: BoxFit.cover,
                    fadeInCurve: Curves.easeInOut,
                    fadeOutDuration: Duration(milliseconds: 300),
                    placeholder: (context, url) => Container(
                      color: Colors.grey,
                    ),
                    errorWidget: (context, url, error) =>
                        Container(child: Icon(Icons.error)),
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  '${widget.model.name}',
                  style: kValueStyle.copyWith(
                      fontSize: 18.0, color: ThemeColors.primaryBlue),
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
            margin: EdgeInsets.only(bottom: 5.0, top: 10.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Visibility(
                  visible: widget.model.address != null,
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.location_on,
                        color: ThemeColors.primaryBlue,
                        size: 11.0,
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        '${widget.model.address}',
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
                Expanded(
                  child: Text(
                    '${widget.model.follower} Mengikuti',
                    textAlign: TextAlign.right,
                    style: kValueStyle.copyWith(
                        fontSize: 11.0, color: ThemeColors.primaryBlue),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Stack(
            children: <Widget>[
              InkWell(
                onTap: () async {
                  var result = await Navigator.of(context)
                      .pushNamed(CommunityDetailPage.routeName, arguments: {
                    CommunityDetailPage.communitySlug: widget.model.slug,
                  });

                  if (result == 'refresh') {
                    setState(() {
                      widget.model.isJoin = !widget.model.isJoin;
                    });
                  }
                },
                child: CachedNetworkImage(
                  imageUrl: widget.model?.cover,
                  imageBuilder: (context, imageProvider) => Container(
                    width: double.infinity,
                    height: 200.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        image: DecorationImage(
                            fit: BoxFit.cover, image: imageProvider)),
                  ),
                  fadeInCurve: Curves.easeIn,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  fadeOutDuration: Duration(milliseconds: 500),
                  errorWidget: (context, url, error) =>
                      Container(child: Icon(Icons.error)),
                ),
              ),
              Positioned(
                top: 10.0,
                left: 10.0,
                child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          ThemeColors.red,
                          Colors.red,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12.0)),
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      '${widget.model.categoryName}',
                      style: Constants.kValueStyle.copyWith(
                          color: Colors.white,
                          fontSize: 11.0,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
            ],
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
                color: ThemeColors.primaryBlue,
                size: 15.0,
              ),
              SizedBox(
                width: 3.0,
              ),
              Text(
                '${widget.model.ranting ?? 0}',
                style: kValueStyle.copyWith(
                    fontSize: 12.0, color: ThemeColors.primaryBlue),
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
                              CommunityDetailPage.communitySlug:
                                  widget.model.slug,
                            });

                        if (result == 'refresh') {
                          ///refresh here
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: ThemeColors.primaryBlue, width: 2.0),
                            borderRadius: BorderRadius.circular(5.0)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4.0),
                          child: Text(
                            'Kunjungi',
                            style: Constants.kValueStyle.copyWith(
                                color: ThemeColors.primaryBlue,
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
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: ThemeColors.primaryBlue,
                            borderRadius: BorderRadius.circular(4.0)),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              widget.model.isJoin = !widget.model.isJoin;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Text(
                              'Gabung Komunitas',
                              style: kValueStyle.copyWith(
                                  color: Colors.white,
                                  fontSize: 11.0,
                                  fontWeight: FontWeight.w500),
                              textAlign: TextAlign.center,
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
        ],
      ),
    );
  }
}
