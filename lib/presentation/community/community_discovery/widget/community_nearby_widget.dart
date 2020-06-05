import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localin/components/custom_image_radius.dart';
import 'package:localin/components/shared_community_components/community_empty_page.dart';
import 'package:localin/presentation/community/provider/community_nearby_provider.dart';
import 'package:localin/presentation/others_profile/widgets/empty_other_user_community_widget.dart';
import 'package:localin/presentation/shared_widgets/empty_article_with_custom_message.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

class CommunityNearbyWidget extends StatelessWidget {
  CommunityNearbyWidget({Key key}) : super(key: key);

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
        Consumer<CommunityNearbyProvider>(
          builder: (context, provider, child) {
            return StreamBuilder<communityNearbyState>(
                stream: provider.communityStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting &&
                      provider.offset <= 1) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: provider.communityNearbyList.length + 1,
                    itemBuilder: (context, index) {
                      if (provider.communityNearbyList.isEmpty &&
                          provider.offset <= 2) {
                        return CommunityEmptyPage();
                      } else if (index < provider.communityNearbyList.length) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 12.0, horizontal: 20.0),
                          child: Row(
                            children: <Widget>[
                              CustomImageRadius(
                                height: 80.0,
                                width: 80.0,
                                radius: 8.0,
                                imageUrl: provider
                                    .communityNearbyList[index]?.logoUrl,
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
                                      '${provider.communityNearbyList[index]?.categoryName}'
                                          .toUpperCase(),
                                      style: ThemeText.sfSemiBoldFootnote
                                          .copyWith(color: ThemeColors.black80),
                                    ),
                                    Text(
                                      '${provider.communityNearbyList[index]?.name}',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: ThemeText.rodinaHeadline,
                                    ),
                                    Text(
                                      '${provider.communityNearbyList[index]?.totalMember} members',
                                      style: ThemeText.sfMediumBody
                                          .copyWith(color: ThemeColors.black80),
                                    )
                                  ],
                                ),
                              ),
                              Visibility(
                                visible:
                                    !provider.communityNearbyList[index].isJoin,
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4.0),
                                      border: Border.all(
                                          color: ThemeColors.black20)),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 20.0),
                                    child: Text(
                                      'Join',
                                      style: ThemeText.rodinaHeadline.copyWith(
                                          color: ThemeColors.primaryBlue),
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
                  );
                });
          },
        )
      ],
    );
  }
}
