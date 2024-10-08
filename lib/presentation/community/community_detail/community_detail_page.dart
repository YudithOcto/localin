import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localin/model/community/community_detail.dart';
import 'package:localin/presentation/bottom_navigation/main_bottom_navigation.dart';
import 'package:localin/presentation/community/community_detail/provider/community_detail_event_provider.dart';
import 'package:localin/presentation/community/community_detail/provider/community_detail_provider.dart';
import 'package:localin/presentation/community/community_detail/widget/community_detail_upcoming_events_widget.dart';
import 'package:localin/presentation/community/community_detail/widget/community_news_activity_widget.dart';
import 'package:localin/presentation/community/community_detail/widget/community_settings_widget.dart';
import 'package:localin/presentation/community/community_detail/widget/sliver_appbar_widget.dart';
import 'package:localin/presentation/community/provider/comment/community_retrieve_comment_provider.dart';
import 'package:localin/presentation/shared_widgets/empty_community_with_custom_message.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

class CommunityDetailPage extends StatelessWidget {
  static const routeName = 'CommunityDetailPage';
  static const communityData = 'CommunityData';
  static const needBackToHome = 'needBackToHome';

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    bool isNeedToBackHome =
        routeArgs[CommunityDetailPage.needBackToHome] ?? false;
    CommunityDetail cDetail =
        routeArgs[CommunityDetailPage.communityData] ?? CommunityDetail();
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<CommunityDetailProvider>(
            create: (_) => CommunityDetailProvider(),
          ),
          ChangeNotifierProvider<CommunityRetrieveCommentProvider>(
            create: (_) => CommunityRetrieveCommentProvider(),
          ),
          ChangeNotifierProvider<CommunityDetailEventProvider>(
            create: (_) => CommunityDetailEventProvider(),
          ),
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
            isNeedToBackHome: isNeedToBackHome,
            slug: cDetail.slug,
          ),
        ));
  }
}

class CommunityDetailColumn extends StatefulWidget {
  final bool isNeedToBackHome;
  final String slug;

  CommunityDetailColumn({this.isNeedToBackHome = false, this.slug});

  @override
  _CommunityDetailColumnState createState() => _CommunityDetailColumnState();
}

class _CommunityDetailColumnState extends State<CommunityDetailColumn> {
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<CommunityDetailProvider>(context, listen: false)
          .getCommunityDetail(widget.slug);
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.greyDark,
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            if (widget.isNeedToBackHome) {
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
          Consumer<CommunityDetailProvider>(
            builder: (context, provider, child) {
              return Visibility(
                visible: provider.communityDetail != null &&
                    provider.communityDetail.joinStatus == 'View',
                child: InkWell(
                  onTap: () {
                    final provider = Provider.of<CommunityDetailProvider>(
                        context,
                        listen: false);
                    showModalBottomSheet(
                        context: context,
                        enableDrag: true,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12.0),
                                topRight: Radius.circular(12.0))),
                        builder: (ctx) => CommunitySettingsWidget(
                              provider: provider,
                              isAdmin:
                                  provider.communityDetail?.loginStatusType,
                              communityDetail: provider.communityDetail,
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
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<communityDetailState>(
        stream: Provider.of<CommunityDetailProvider>(context, listen: false)
            .streamDetailState,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.data == communityDetailState.empty) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: EmptyCommunityWithCustomMessage(
                  title: 'Community',
                  message:
                      'You are not eligible yet to view this community. Please wait until your member request '
                      'accepted by the admin.',
                ),
              );
            } else {
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
                body: Consumer<CommunityDetailProvider>(
                  builder: (context, provider, child) {
                    return ListView(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      children: <Widget>[
                        CommunityDetailUpcomingEventsWidget(
                          communityId: provider?.communityDetail?.id,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 24.0, left: 20.0, bottom: 8.0),
                          child: Text(
                            'NEWS ACTIVITY',
                            style: ThemeText.sfSemiBoldFootnote
                                .copyWith(color: ThemeColors.black80),
                          ),
                        ),
                        CommunityNewsActivityWidget(
                          communityDetail: provider?.communityDetail ?? null,
                        )
                      ],
                    );
                  },
                ),
              );
            }
          }
        },
      ),
      floatingActionButton: Consumer<CommunityDetailProvider>(
        builder: (context, provider, child) {
          return Visibility(
              visible: provider.communityDetail == null
                  ? false
                  : provider.communityDetail.features.chat &&
                          provider.communityDetail.isJoin ??
                      false,
              child: SvgPicture.asset('images/chat_room.svg'));
        },
      ),
    );
  }
}
