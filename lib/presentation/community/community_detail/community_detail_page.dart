import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localin/model/community/community_detail.dart';
import 'package:localin/presentation/bottom_navigation/main_bottom_navigation.dart';
import 'package:localin/presentation/community/community_detail/widget/community_news_activity_widget.dart';
import 'package:localin/presentation/community/community_detail/widget/community_settings_widget.dart';
import 'package:localin/presentation/community/community_detail/widget/sliver_appbar_widget.dart';
import 'package:localin/presentation/community/provider/comment/community_retrieve_comment_provider.dart';
import 'package:localin/presentation/community/community_detail/provider/community_detail_provider.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

class CommunityDetailPage extends StatelessWidget {
  static const routeName = 'CommunityDetailPage';
  static const communityData = '/communityData';
  static const needBackToHome = 'needBackToHome';

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    CommunityDetail _communityDetail =
        routeArgs[CommunityDetailPage.communityData];
    bool isNeedToBackHome =
        routeArgs[CommunityDetailPage.needBackToHome] ?? false;
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
        child: WillPopScope(
          onWillPop: () async {
            if (isNeedToBackHome) {
              Navigator.of(context)
                  .pushReplacementNamed(MainBottomNavigation.routeName);
            } else {
              Navigator.of(context).pop();
            }
            return false;
          },
          child: CommunityDetailColumn(
            adminId: _communityDetail.createBy,
            communityDetail: _communityDetail,
            isNeedToBackHome: isNeedToBackHome,
          ),
        ));
  }
}

class CommunityDetailColumn extends StatelessWidget {
  final String adminId;
  final CommunityDetail communityDetail;
  final bool isNeedToBackHome;
  CommunityDetailColumn(
      {this.adminId,
      @required this.communityDetail,
      this.isNeedToBackHome = false});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.greyDark,
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            if (isNeedToBackHome) {
              Navigator.of(context)
                  .pushReplacementNamed(MainBottomNavigation.routeName);
            } else {
              Navigator.of(context).pop();
            }
          },
          child: Icon(
            Icons.arrow_back,
            color: ThemeColors.black0,
          ),
        ),
        backgroundColor: Color(0xFF1F75E1),
        elevation: 0.0,
        title: Text(
          'Community',
          style: ThemeText.sfMediumHeadline.copyWith(color: ThemeColors.black0),
        ),
        actions: <Widget>[
          InkWell(
            onTap: () {
              final provider =
                  Provider.of<CommunityDetailProvider>(context, listen: false);
              showModalBottomSheet(
                  context: context,
                  enableDrag: true,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12.0),
                          topRight: Radius.circular(12.0))),
                  builder: (ctx) => CommunitySettingsWidget(
                        provider: provider,
                        isAdmin: provider.communityDetail.loginStatusType,
                        communityDetail: communityDetail,
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
      body: StreamBuilder(
        stream: Provider.of<CommunityDetailProvider>(context, listen: false)
            .streamDetailState,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return NestedScrollView(
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
          );
        },
      ),
      floatingActionButton: Visibility(
          visible: communityDetail.communityType == 'paid',
          child: SvgPicture.asset('images/chat_room.svg')),
    );
  }
}
