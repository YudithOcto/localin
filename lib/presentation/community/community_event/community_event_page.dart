import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localin/presentation/community/community_event/provider/community_event_provider.dart';
import 'package:localin/presentation/community/community_event/widgets/community_list_upcoming_events.dart';
import 'package:localin/presentation/community/community_event/widgets/empty_event.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

class CommunityEventPage extends StatelessWidget {
  static const routeName = 'CommunityEventPage';
  static const communityId = 'CommunityId';

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    String communityId = routeArgs[CommunityEventPage.communityId];
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CommunityEventProvider>(
          create: (_) => CommunityEventProvider(communityId),
        )
      ],
      child: CommunityEventWrapper(),
    );
  }
}

class CommunityEventWrapper extends StatefulWidget {
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
          CommunityListUpcomingEvents(),
          EmptyEvent(
            text: 'This group doesn’t have any past events',
          ),
        ],
      ),
    );
  }
}
