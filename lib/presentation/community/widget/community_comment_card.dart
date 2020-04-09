import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:localin/model/community/community_comment_base_response.dart';
import 'package:localin/presentation/profile/profile_page.dart';
import 'package:localin/utils/date_helper.dart';

import '../../../themes.dart';

class CommunityCommentCard extends StatelessWidget {
  final int index;
  final CommunityComment commentDetail;
  CommunityCommentCard({this.index, this.commentDetail});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              CachedNetworkImage(
                imageUrl: '${commentDetail?.createdAvatar}',
                imageBuilder: (context, imageProvider) {
                  return CircleAvatar(
                    backgroundImage: imageProvider,
                  );
                },
                errorWidget: (ctx, item, child) => CircleAvatar(
                  child: Icon(Icons.person),
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '${commentDetail?.createdName}',
                    style: kValueStyle.copyWith(color: ThemeColors.primaryBlue),
                  ),
                  Text(
                    '${DateHelper.formatDateFromApi(commentDetail?.updatedAt)}',
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
            '${commentDetail?.commentContent}',
            style: kValueStyle.copyWith(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
                fontSize: 12.0),
          ),
          Visibility(
            visible: false,
            child: SizedBox(
              height: 10.0,
            ),
          ),
          Visibility(
            visible: false,
            child: Text(
              '#ITCommunity #IsengItuSukses',
              style: kValueStyle.copyWith(
                  color: ThemeColors.primaryBlue,
                  fontWeight: FontWeight.w500,
                  fontSize: 12.0),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          CachedNetworkImage(
            imageUrl: '${commentDetail?.attachment}',
            errorWidget: (context, item, child) => Container(
              height: 150.0,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.grey,
              ),
            ),
            imageBuilder: (context, imageProvider) {
              return Container(
                height: 150.0,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.grey,
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover)),
              );
            },
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.thumb_up,
                    color: ThemeColors.primaryBlue,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    '0 Sukai',
                    style: kValueStyle.copyWith(
                        color: ThemeColors.primaryBlue, fontSize: 12.0),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.comment,
                    color: ThemeColors.primaryBlue,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    '0 Komentar',
                    style: kValueStyle.copyWith(
                        color: ThemeColors.primaryBlue, fontSize: 12.0),
                  )
                ],
              ),
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
