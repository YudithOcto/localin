import 'package:flutter/material.dart';
import 'package:localin/presentation/community/community_members/admin_tab/community_admin_tab_provider.dart';
import 'package:localin/presentation/community/community_members/admin_tab/community_admin_tab_widget.dart';
import 'package:localin/presentation/community/community_members/blocked_tab/community_blocked_tab_provider.dart';
import 'package:localin/presentation/community/community_members/blocked_tab/community_blocked_tab_widget.dart';
import 'package:localin/presentation/community/community_members/members_tab/community_members_tab_provider.dart';
import 'package:localin/presentation/community/community_members/members_tab/community_members_tab_widget.dart';
import 'package:localin/presentation/community/community_members/request_tab/community_request_tab_provider.dart';
import 'package:localin/presentation/community/community_members/request_tab/community_request_tab_widget.dart';
import 'package:localin/provider/community_member_provider.dart';
import 'package:provider/provider.dart';

import '../../../text_themes.dart';
import '../../../themes.dart';

class CommunityMembersPage extends StatelessWidget {
  static const routeName = 'CommunityMembersPage';
  static const communityId = 'CommunityId';
  static const isAdmin = 'isAdmin';

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    String comId = routeArgs[CommunityMembersPage.communityId];
    bool isAdmin = routeArgs[CommunityMembersPage.isAdmin];
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CommunityAdminTabProvider>(
          create: (_) =>
              CommunityAdminTabProvider(communityId: comId, isAdmin: isAdmin),
        ),
        ChangeNotifierProvider<CommunityMembersTabProvider>(
          create: (_) =>
              CommunityMembersTabProvider(communityId: comId, isAdmin: isAdmin),
        ),
        ChangeNotifierProvider<CommunityRequestTabProvider>(
          create: (_) =>
              CommunityRequestTabProvider(communityId: comId, isAdmin: isAdmin),
        ),
        ChangeNotifierProvider<CommunityBlockedTabProvider>(
          create: (_) =>
              CommunityBlockedTabProvider(communityId: comId, isAdmin: isAdmin),
        ),
        ChangeNotifierProvider<CommunityMemberProvider>(
          create: (_) =>
              CommunityMemberProvider(communityId: comId, isAdmin: isAdmin),
        )
      ],
      child: CommunityMemberWrapperContent(
        isAdmin: isAdmin,
      ),
    );
  }
}

class CommunityMemberWrapperContent extends StatefulWidget {
  final bool isAdmin;

  CommunityMemberWrapperContent({this.isAdmin});

  @override
  _CommunityMemberWrapperContentState createState() =>
      _CommunityMemberWrapperContentState();
}

class _CommunityMemberWrapperContentState
    extends State<CommunityMemberWrapperContent>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  List<Widget> tabs = List();
  List<Widget> tabBarViewList = List();

  @override
  void initState() {
    _tabController = TabController(length: widget.isAdmin ? 4 : 2, vsync: this);
    _initializeTab();
    _initializeTabViewList();
    super.initState();
  }

  _initializeTabViewList() {
    tabBarViewList.add(CommunityMembersTabWidget());
    tabBarViewList.add(CommunityAdminTabWidget());
    if (widget.isAdmin) {
      tabBarViewList.add(CommunityRequestTabWidget());
      tabBarViewList.add(CommunityBlockedTabWidget());
    }
  }

  _initializeTab() {
    tabs.add(insertTab('Members'));
    tabs.add(insertTab('Admin'));
    if (widget.isAdmin) {
      tabs.add(insertTab('Request'));
      tabs.add(insertTab('Blocked'));
    }
  }

  insertTab(String text) {
    return Tab(
      text: text,
    );
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
            tabs: tabs,
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: tabBarViewList,
        ),
      ),
    );
  }
}
