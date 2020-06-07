import 'package:flutter/material.dart';
import 'package:localin/components/custom_app_bar.dart';
import 'package:localin/presentation/community/community_members/members_tab/community_members_tab_widget.dart';

import '../../../text_themes.dart';
import '../../../themes.dart';

class CommunityMembersPage extends StatefulWidget {
  static const routeName = 'CommunityMembersPage';

  @override
  _CommunityMembersPageState createState() => _CommunityMembersPageState();
}

class _CommunityMembersPageState extends State<CommunityMembersPage>
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
            Container(),
            Container(),
            Container(),
          ],
        ),
      ),
    );
  }
}
