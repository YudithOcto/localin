import 'package:flutter/material.dart';
import 'package:localin/components/circle_image.dart';
import 'package:localin/components/custom_dialog.dart';
import 'package:localin/components/user_profile_box_widget.dart';
import 'package:localin/presentation/community/community_detail/create_post_page.dart';
import 'package:localin/presentation/community/community_detail/provider/community_detail_provider.dart';
import 'package:localin/presentation/community/provider/comment/community_retrieve_comment_provider.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

class SliverAppBarWidget extends SliverPersistentHeaderDelegate {
  @override
  double get minExtent => 160 - kToolbarHeight;
  @override
  double get maxExtent => 300 - kToolbarHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Consumer<CommunityDetailProvider>(
      builder: (context, provider, child) {
        double h = maxExtent - shrinkOffset;
        return SizedBox(
          height: (h < minExtent) ? minExtent : h,
          child: Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage('images/news_base.png'),
                  fit: BoxFit.cover,
                )),
              ),
              Wrap(
                children: <Widget>[
                  expandedRow(context, provider, shrinkOffset),
                  collapsedRow(context, provider, shrinkOffset)
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget expandedRow(BuildContext context, CommunityDetailProvider provider,
      double shrinkOffset) {
    return AnimatedOpacity(
      opacity: shrinkOffset > 150 ? 0 : 1,
      duration: Duration(milliseconds: 150),
      child: Visibility(
        visible: shrinkOffset < 170,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    UserProfileImageWidget(
                      imageUrl: '${provider.communityDetail?.logo ?? ''}',
                      fit: BoxFit.cover,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '${provider.communityDetail?.name}',
                          textAlign: TextAlign.center,
                          style: ThemeText.rodinaTitle3
                              .copyWith(color: ThemeColors.black0),
                        ),
                        Visibility(
                          visible:
                              provider.communityDetail?.totalMember == null,
                          child: Text(
                            '${provider.communityDetail?.totalMember ?? 0} members',
                            textAlign: TextAlign.end,
                            style: ThemeText.sfMediumBody.copyWith(
                                color: ThemeColors.black0.withOpacity(0.6)),
                          ),
                        )
                      ],
                    )
                  ],
                ),
                memberRow(provider),
                Text(
                  '${provider.communityDetail?.categoryName} • ${provider.communityDetail?.address}',
                  style: ThemeText.sfMediumFootnote
                      .copyWith(color: ThemeColors.black0.withOpacity(0.6)),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
                  child: Text(
                    '${provider.communityDetail?.description}',
                    style: ThemeText.sfRegularBody
                        .copyWith(color: ThemeColors.black0),
                  ),
                ),
                Visibility(
                  visible: provider.communityDetail == null
                      ? false
                      : !provider.communityDetail.isJoin,
                  child: Container(
                    width: double.infinity,
                    height: 48.0,
                    child: RaisedButton(
                      elevation: 2.0,
                      color: ThemeColors.black0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0)),
                      onPressed: () async {
                        final result = await provider
                            .joinCommunity(provider.communityDetail.id);
                        if (result.error == null) {
                          CustomDialog.showCustomDialogWithButton(
                              context,
                              'Join Community',
                              '${result.message ?? 'Failed'}');
                        } else {
                          CustomDialog.showCustomDialogWithButton(
                              context,
                              'Join Community',
                              '${result.message ?? 'Success'}');
                        }
                      },
                      child: Text(
                        'Join Community',
                        style: ThemeText.rodinaTitle3
                            .copyWith(color: ThemeColors.primaryBlue),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: provider.communityDetail == null
                      ? false
                      : provider.communityDetail.isJoin,
                  child: Container(
                    width: double.infinity,
                    height: 48.0,
                    child: RaisedButton(
                      elevation: 2.0,
                      color: ThemeColors.black0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      onPressed: () async {
                        final result = await Navigator.of(context)
                            .pushNamed(CreatePostPage.routeName, arguments: {
                          CreatePostPage.communityId:
                              provider.communityDetail.id,
                        });
                        if (result == 'success') {
                          Provider.of<CommunityRetrieveCommentProvider>(context,
                                  listen: false)
                              .getCommentList(
                                  communityId: provider.communityDetail.id,
                                  isRefresh: true);
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Write something',
                            style: ThemeText.sfMediumBody
                                .copyWith(color: ThemeColors.black80),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 20,
                            color: ThemeColors.black60,
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget collapsedRow(BuildContext context, CommunityDetailProvider provider,
      double shrinkOffset) {
    return AnimatedOpacity(
      opacity: shrinkOffset > 150 ? 1 : 0,
      duration: Duration(milliseconds: 150),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SizedBox(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              UserProfileImageWidget(
                imageUrl: '${provider.communityDetail?.logo}',
                fit: BoxFit.cover,
              ),
              SizedBox(
                width: 12,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '${provider.communityDetail?.name}',
                      textAlign: TextAlign.center,
                      style: ThemeText.rodinaHeadline
                          .copyWith(color: ThemeColors.black0),
                    ),
                    Text(
                      '${provider.communityDetail?.totalMember ?? 0} members',
                      style: ThemeText.sfMediumFootnote
                          .copyWith(color: ThemeColors.black0.withOpacity(0.6)),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: provider.communityDetail == null
                    ? false
                    : !provider.communityDetail.isJoin,
                child: InkWell(
                  onTap: () async {
                    final result = await provider
                        .joinCommunity(provider.communityDetail.id);
                    if (result.error == null) {
                      CustomDialog.showCustomDialogWithButton(context,
                          'Join Community', '${result.message ?? 'Failed'}');
                    } else {
                      CustomDialog.showCustomDialogWithButton(context,
                          'Join Community', '${result.message ?? 'Success'}');
                    }
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                    decoration: BoxDecoration(
                        color: ThemeColors.yellow,
                        borderRadius: BorderRadius.circular(4.0)),
                    child: Text(
                      'Join',
                      style: ThemeText.rodinaHeadline
                          .copyWith(color: ThemeColors.black100),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget memberRow(CommunityDetailProvider provider) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 12.0),
      child: Visibility(
        visible: provider.communityDetail?.totalMember != null,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              children: List.generate(4, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: CircleImage(
                    width: 32.0,
                    height: 32.0,
                  ),
                );
              }),
            ),
            SizedBox(
              width: 34.0,
            ),
            Expanded(
              child: Text(
                '${provider.communityDetail?.totalMember ?? 0} members',
                textAlign: TextAlign.end,
                style:
                    ThemeText.sfMediumBody.copyWith(color: ThemeColors.black0),
              ),
            ),
            SizedBox(
              width: 14.0,
            ),
            Icon(
              Icons.chevron_right,
              size: 30,
              color: ThemeColors.black0,
            )
          ],
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(SliverAppBarWidget oldDelegate) {
    return true;
  }
}
