import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:localin/model/community/community_detail.dart';
import 'package:localin/presentation/community/community_detail/community_detail_page.dart';
import 'package:localin/presentation/community/community_discovery/community_discover_my_group_page.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';

class CommunityMyGroupWidget extends StatelessWidget {
  final List<CommunityDetail> userCommunityDetail;
  CommunityMyGroupWidget({@required this.userCommunityDetail});

  @override
  Widget build(BuildContext context) {
    final item = userCommunityDetail.take(3) ?? [];
    return Container(
      height: 150,
      margin: EdgeInsets.only(bottom: 24.0),
      child: ListView.builder(
        itemCount:
            userCommunityDetail.length > 3 ? item.length + 1 : item.length,
        shrinkWrap: true,
        padding: EdgeInsets.only(bottom: 4.0),
        physics: ClampingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          if (index < item.length) {
            return InkWell(
              onTap: () {
                Navigator.of(context)
                    .pushNamed(CommunityDetailPage.routeName, arguments: {
                  CommunityDetailPage.communitySlug:
                      userCommunityDetail[index].slug,
                });
              },
              child: Card(
                elevation: 1.0,
                color: ThemeColors.black0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                margin: EdgeInsets.only(left: index == 0 ? 20.0 : 12.0),
                child: Container(
                  width: 160.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CachedNetworkImage(
                        imageUrl: '${userCommunityDetail[index]?.logoUrl}',
                        errorWidget: (context, _, child) => Container(
                          height: 90.0,
                          decoration: BoxDecoration(
                            color: ThemeColors.black80,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8.0),
                              topRight: Radius.circular(8.0),
                            ),
                          ),
                        ),
                        placeholder: (context, image) => Container(
                          height: 90.0,
                          decoration: BoxDecoration(
                            color: ThemeColors.black80,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8.0),
                              topRight: Radius.circular(8.0),
                            ),
                          ),
                        ),
                        imageBuilder: (context, imageProvider) {
                          return Container(
                            height: 90.0,
                            decoration: BoxDecoration(
                              color: ThemeColors.black80,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8.0),
                                topRight: Radius.circular(8.0),
                              ),
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.cover),
                            ),
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, top: 12.0),
                        child: Text(
                          '${userCommunityDetail[index]?.name}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: ThemeText.sfRegularBody,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            final url = userCommunityDetail[index].logoUrl;
            return InkWell(
              onTap: () {
                Navigator.of(context)
                    .pushNamed(CommunityDiscoverMyGroupPage.routeName);
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 20.0),
                child: Stack(
                  children: <Widget>[
                    Container(
                      height: 150.0,
                      width: 160.0,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              colorFilter: ColorFilter.mode(
                                  ThemeColors.primaryBlue.withOpacity(0.9),
                                  BlendMode.srcOver),
                              image: NetworkImage(
                                url,
                              )),
                          borderRadius: BorderRadius.circular(12.0)),
                    ),
                    Positioned(
                      left: 0.0,
                      right: 0.0,
                      top: 0.0,
                      bottom: 0.0,
                      child: Center(
                        child: Text(
                          '+ ${(userCommunityDetail.length) - item.length} Groups',
                          textAlign: TextAlign.center,
                          style: ThemeText.sfMediumBody
                              .copyWith(color: ThemeColors.black0),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
