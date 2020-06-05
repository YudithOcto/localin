import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localin/model/community/community_detail.dart';
import 'package:localin/presentation/community/community_detail/widget/community_news_activity_widget.dart';
import 'package:localin/presentation/community/community_detail/widget/sliver_appbar_widget.dart';
import 'package:localin/presentation/community/provider/comment/community_retrieve_comment_provider.dart';
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
    return MultiProvider(providers: [
      ChangeNotifierProvider<CommunityDetailProvider>(
        create: (_) =>
            CommunityDetailProvider(communitySlug: _communityDetail.slug),
      ),
      ChangeNotifierProvider<CommunityRetrieveCommentProvider>(
        create: (_) => CommunityRetrieveCommentProvider(),
      )
    ], child: CommunityDetailColumn());
  }
}

class CommunityDetailColumn extends StatelessWidget {
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
          Icon(
            Icons.more_vert,
            color: ThemeColors.black0,
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
