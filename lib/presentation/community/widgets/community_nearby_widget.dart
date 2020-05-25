import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localin/components/custom_image_radius.dart';
import 'package:localin/model/community/community_detail.dart';
import 'package:localin/presentation/community/provider/community_feed_provider.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

class CommunityNearbyWidget extends StatelessWidget {
  final List<CommunityDetail> communityList;
  CommunityNearbyWidget({@required this.communityList});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
          child: Row(
            children: <Widget>[
              SvgPicture.asset('images/star_orange.svg'),
              SizedBox(
                width: 5.67,
              ),
              Text(
                'Community around me',
                style: ThemeText.sfSemiBoldHeadline,
              )
            ],
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemCount: communityList.length + 1 ?? 1,
          itemBuilder: (context, index) {
            final provider =
                Provider.of<CommunityFeedProvider>(context, listen: false);
            if (communityList.length == 0 && provider.offset <= 1) {
              return Container();
            } else if (index < communityList.length) {
              return Container(
                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                child: Row(
                  children: <Widget>[
                    CustomImageRadius(
                      height: 80.0,
                      width: 80.0,
                      radius: 8.0,
                      imageUrl: communityList[index]?.logoUrl,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(
                      width: 12.0,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '${communityList[index]?.categoryName}'
                                .toUpperCase(),
                            style: ThemeText.sfSemiBoldFootnote
                                .copyWith(color: ThemeColors.black80),
                          ),
                          Text(
                            '${communityList[index]?.name}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: ThemeText.rodinaHeadline,
                          ),
                          Text(
                            '${communityList[index]?.totalMember} members',
                            style: ThemeText.sfMediumBody
                                .copyWith(color: ThemeColors.black80),
                          )
                        ],
                      ),
                    ),
                    Visibility(
                      visible: !communityList[index]?.isJoin,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.0),
                            border: Border.all(color: ThemeColors.black20)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 20.0),
                          child: Text(
                            'Join',
                            style: ThemeText.rodinaHeadline
                                .copyWith(color: ThemeColors.primaryBlue),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            } else if (provider.canLoadMore) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Container();
            }
          },
        )
      ],
    );
  }
}
