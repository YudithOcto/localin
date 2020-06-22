import 'package:flutter/material.dart';
import 'package:localin/presentation/community/community_members/admin_tab/community_admin_tab_widget.dart';
import 'package:localin/presentation/community/community_members/blocked_tab/community_blocked_tab_provider.dart';
import 'package:localin/presentation/community/community_members/blocked_tab/community_blocked_tab_widget.dart';
import 'package:localin/presentation/community/community_members/members_tab/community_members_tab_widget.dart';
import 'package:localin/presentation/community/community_members/admin_tab/community_admin_tab_provider.dart';
import 'package:localin/presentation/community/community_members/members_tab/community_members_tab_provider.dart';
import 'package:localin/presentation/community/community_members/request_tab/community_request_tab_provider.dart';
import 'package:localin/presentation/community/community_members/request_tab/community_request_tab_widget.dart';
import 'package:localin/provider/community_member_provider.dart';
import 'package:provider/provider.dart';

import '../../../text_themes.dart';
import '../../../themes.dart';

class CommunityMembersPage extends StatelessWidget {
  static const routeName = 'CommunityMembersPage';
  static const communityId = 'CommunityId';

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    String comId = routeArgs[CommunityMembersPage.communityId];
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CommunityAdminTabProvider>(
          create: (_) => CommunityAdminTabProvider(communityId: comId),
        ),
        ChangeNotifierProvider<CommunityMembersTabProvider>(
          create: (_) => CommunityMembersTabProvider(communityId: comId),
        ),
        ChangeNotifierProvider<CommunityRequestTabProvider>(
          create: (_) => CommunityRequestTabProvider(communityId: comId),
        ),
        ChangeNotifierProvider<CommunityBlockedTabProvider>(
          create: (_) => CommunityBlockedTabProvider(communityId: comId),
        ),
        ChangeNotifierProvider<CommunityMemberProvider>(
          create: (_) => CommunityMemberProvider(communityId: comId),
        )
      ],
      child: CommunityMemberWrapperContent(),
    );
  }
}

class CommunityMemberWrapperContent extends StatefulWidget {
  @override
  _CommunityMemberWrapperContentState createState() =>
      _CommunityMemberWrapperContentState();
}

class _CommunityMemberWrapperContentState
    extends State<CommunityMemberWrapperContent>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ThemeColors.black0,
          elevation: 0.0,
          leading: InkWell(
            onTap: () => Navigator.of(context).pop(),
            child: Icon(
              Icons.arrow_back,
              color: ThemeColors.black80,
            ),
          ),
          title: Text(
            'Members',
            style: ThemeText.sfMediumHeadline,
          ),
          bottom: TabBar(
            unselectedLabelColor: ThemeColors.black60,
            labelColor: ThemeColors.primaryBlue,
            unselectedLabelStyle: ThemeText.sfSemiBoldBody,
            labelStyle: ThemeText.sfSemiBoldBody,
            controller: _tabController,
            tabs: <Widget>[
              Tab(
                text: 'Members',
              ),
              Tab(
                text: 'Admin',
              ),
              Tab(
                text: 'Request',
              ),
              Tab(
                text: 'Blocked',
              )
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            CommunityMembersTabWidget(),
            CommunityAdminTabWidget(),
            CommunityRequestTabWidget(),
            CommunityBlockedTabWidget(),
          ],
        ),
      ),
    );
  }
}
