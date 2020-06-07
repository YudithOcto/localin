import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localin/model/community/community_detail.dart';
import 'package:localin/presentation/community/community_detail/widget/community_news_activity_widget.dart';
import 'package:localin/presentation/community/community_detail/widget/community_settings_widget.dart';
import 'package:localin/presentation/community/community_detail/widget/sliver_appbar_widget.dart';
import 'package:localin/presentation/community/provider/comment/community_retrieve_comment_provider.dart';
import 'package:localin/provider/auth_provider.dart';
import 'package:localin/provider/community/community_detail_provider.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

class CommunityDetailPage extends StatelessWidget {
  static const routeName = 'CommunityDetailPage';
  static const communityData = '/communityData';

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    CommunityDetail _communityDetail =
        routeArgs[CommunityDetailPage.communityData];
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<CommunityDetailProvider>(
            create: (_) =>
                CommunityDetailProvider(communitySlug: _communityDetail.slug),
          ),
          ChangeNotifierProvider<CommunityRetrieveCommentProvider>(
            create: (_) => CommunityRetrieveCommentProvider(),
          )
        ],
        child: CommunityDetailColumn(
          adminId: _communityDetail.createBy,
        ));
  }
}

class CommunityDetailColumn extends StatelessWidget {
  final String adminId;
  CommunityDetailColumn({this.adminId});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.greyDark,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Color(0xFF1F75E1),
        elevation: 0.0,
        title: Text(
          'Community',
          style: ThemeText.sfMediumHeadline.copyWith(color: ThemeColors.black0),
        ),
        actions: <Widget>[
          InkWell(
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  enableDrag: true,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12.0),
                          topRight: Radius.circular(12.0))),
                  builder: (ctx) => CommunitySettingsWidget(
                        isAdmin: adminId ==
                            Provider.of<AuthProvider>(context, listen: false)
                                .userModel
                                .id,
                      ));
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: Icon(
                Icons.more_vert,
                color: ThemeColors.black0,
              ),
            ),
          ),
        ],
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBox) {
          return <Widget>[
            SliverPersistentHeader(
              floating: false,
              pinned: true,
              delegate: SliverAppBarWidget(),
            )
          ];
        },
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.only(top: 24.0, left: 20.0, bottom: 8.0),
              child: Text(
                'NEWS ACTIVITY',
                style: ThemeText.sfSemiBoldFootnote
                    .copyWith(color: ThemeColors.black80),
              ),
            ),
            CommunityNewsActivityWidget(),
          ],
        ),
      ),
      floatingActionButton: SvgPicture.asset('images/chat_room.svg'),
    );
  }
}
