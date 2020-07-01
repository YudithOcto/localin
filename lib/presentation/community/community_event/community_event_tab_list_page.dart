import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localin/components/custom_dialog.dart';
import 'package:localin/components/custom_toast.dart';
import 'package:localin/model/community/community_detail.dart';
import 'package:localin/presentation/community/community_event/community_create_event_page.dart';
import 'package:localin/presentation/community/community_event/provider/community_event_provider.dart';
import 'package:localin/presentation/community/community_event/widgets/community_event_past_list.dart';
import 'package:localin/presentation/community/community_event/widgets/community_event_upcoming_list.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

class CommunityEventTabListPage extends StatelessWidget {
  static const routeName = 'CommunityEventPage';
  static const communityId = 'CommunityDetail';

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    CommunityDetail _communityDetail =
        routeArgs[CommunityEventTabListPage.communityId];
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CommunityEventProvider>(
          create: (_) => CommunityEventProvider(_communityDetail.id),
        )
      ],
      child: CommunityEventWrapper(
        communityDetail: _communityDetail,
      ),
    );
  }
}

class CommunityEventWrapper extends StatefulWidget {
  final CommunityDetail communityDetail;
  CommunityEventWrapper({this.communityDetail});

  @override
  _CommunityEventWrapperState createState() => _CommunityEventWrapperState();
}

class _CommunityEventWrapperState extends State<CommunityEventWrapper>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 2);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.greyDark,
      appBar: AppBar(
        backgroundColor: ThemeColors.black0,
        titleSpacing: 0.0,
        leading: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: Icon(
            Icons.arrow_back,
            color: ThemeColors.black80,
          ),
        ),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 20.0),
            child: InkWell(
              onTap: () async {
                if (widget.communityDetail.isAdmin &&
                    widget.communityDetail.features.event) {
                  final response = await Navigator.of(context).pushNamed(
                      CommunityCreateEventPage.routeName,
                      arguments: {
                        CommunityCreateEventPage.communityData:
                            widget.communityDetail,
                      });
                  if (response != null && response == 'success') {
                    Provider.of<CommunityEventProvider>(context, listen: false)
                        .getUpcomingEvent();
                  }
                } else {
                  if (!widget.communityDetail.features.event) {
                    CustomToast.showCustomBookmarkToast(context,
                        'You need to upgrade to pro community to use this feature.',
                        duration: 1);
                  } else {
                    CustomToast.showCustomBookmarkToast(
                        context, 'Only admin can create event',
                        duration: 1);
                  }
                }
              },
              child: Row(
                children: <Widget>[
                  Text(
                    'Create',
                    style: ThemeText.sfSemiBoldBody
                        .copyWith(color: ThemeColors.primaryBlue),
                  ),
                  SizedBox(
                    width: 5.67,
                  ),
                  SvgPicture.asset('images/plus_icon.svg'),
                ],
              ),
            ),
          )
        ],
        title: Text(
          'Events',
          overflow: TextOverflow.ellipsis,
          style: ThemeText.sfMediumHeadline,
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(40),
          child: Align(
            alignment: FractionalOffset.centerLeft,
            child: TabBar(
              isScrollable: true,
              controller: _tabController,
              labelStyle: ThemeText.sfSemiBoldBody,
              labelColor: ThemeColors.primaryBlue,
              unselectedLabelColor: ThemeColors.black60,
              tabs: <Widget>[
                Tab(
                  text: 'Upcoming',
                ),
                Tab(
                  text: 'Past',
                ),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          CommunityEventUpcomingList(),
          CommunityEventPastList(),
        ],
      ),
    );
  }
}
