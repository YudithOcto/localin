import 'package:flutter/material.dart';
import 'package:localin/presentation/community/community_event/widgets/member_going/community_event_going_member_provider.dart';
import 'package:localin/presentation/community/community_event/widgets/member_going/community_member_list_widget.dart';
import 'package:localin/presentation/community/community_event/widgets/member_tentative/event_member_tentative_provider.dart';
import 'package:localin/presentation/community/community_event/widgets/member_tentative/event_member_tentative_widget.dart';
import 'package:localin/presentation/community/community_event/widgets/member_waiting/event_member_waiting_provider.dart';
import 'package:localin/presentation/community/community_event/widgets/member_waiting/event_member_waiting_widget.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

class CommunityEventMemberPage extends StatelessWidget {
  static const routeName = 'CommunityEventMemberPage';
  static const eventId = 'EventId';

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CommunityEventGoingMemberProvider>(
          create: (_) => CommunityEventGoingMemberProvider(),
        ),
        ChangeNotifierProvider<EventMemberTentativeProvider>(
          create: (_) => EventMemberTentativeProvider(),
        ),
        ChangeNotifierProvider<EventMemberWaitingProvider>(
          create: (_) => EventMemberWaitingProvider(),
        )
      ],
      child: CommunityEventMemberWrapper(),
    );
  }
}

class CommunityEventMemberWrapper extends StatefulWidget {
  @override
  _CommunityEventMemberWrapperState createState() =>
      _CommunityEventMemberWrapperState();
}

class _CommunityEventMemberWrapperState
    extends State<CommunityEventMemberWrapper>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ThemeColors.black0,
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
          title: Text(
            'Attendees',
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
                    text: 'Going',
                  ),
                  Tab(
                    text: 'Tentative',
                  ),
                  Tab(
                    text: 'Waiting',
                  ),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            CommunityMemberListWidget(),
            EventMemberTentativeWidget(),
            EventMemberWaitingWidget(),
          ],
        ));
  }
}
