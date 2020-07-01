import 'package:flutter/material.dart';
import 'package:localin/presentation/community/community_members/members_tab/community_members_tab_provider.dart';
import 'package:localin/presentation/community/community_members/shared_members_widget/custom_member_text_form_field_widget.dart';
import 'package:localin/presentation/community/community_members/shared_members_widget/enum_members.dart';
import 'package:localin/presentation/community/community_members/shared_members_widget/single_member_widget.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/utils/constants.dart';
import 'package:localin/utils/date_helper.dart';
import 'package:localin/utils/debounce.dart';
import 'package:provider/provider.dart';

class CommunityMembersTabWidget extends StatefulWidget {
  @override
  _CommunityMembersTabWidgetState createState() =>
      _CommunityMembersTabWidgetState();
}

class _CommunityMembersTabWidgetState extends State<CommunityMembersTabWidget> {
  bool _isInit = true;
  final _scrollController = ScrollController();
  final _debounce = Debounce(milliseconds: 400);

  @override
  void didChangeDependencies() {
    if (_isInit) {
      loadData(isRefresh: true);
      _scrollController
        ..addListener(() {
          if (_scrollController.offset >
              _scrollController.position.maxScrollExtent) {
            loadData(isRefresh: false);
          }
        });
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  loadData({bool isRefresh = false}) async {
    Provider.of<CommunityMembersTabProvider>(context, listen: false)
        .getMembersCommunity(isRefresh: isRefresh);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Consumer<CommunityMembersTabProvider>(
        builder: (context, provider, child) {
          return Column(
            children: <Widget>[
              CustomMemberTextFormFieldWidget(onChange: (v) {
                _debounce.run(() {
                  provider.requestSearchKeyword = v;
                });
              }),
              StreamBuilder<communityMemberState>(
                stream: provider.memberStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting &&
                      provider.currentPageRequest <= 1) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return ListView.builder(
                      physics: ClampingScrollPhysics(),
                      shrinkWrap: true,
                      controller: _scrollController,
                      itemCount: provider.memberList.length + 1,
                      itemBuilder: (context, index) {
                        if (snapshot.data == communityMemberState.empty) {
                          return Container(
                            child: Text(
                              'No Member',
                              textAlign: TextAlign.center,
                              style: ThemeText.rodinaTitle3,
                            ),
                          );
                        } else if (index < provider.memberList.length) {
                          final item = provider.memberList[index];
                          return SingleMemberWidget(
                            isOnlyAdminTab: false,
                            detail: item,
                            rowDescription:
                                'Joined ${DateHelper.timeAgo(DateTime.parse(item.joinedDate))}',
                            onRefresh: () =>
                                provider.getMembersCommunity(isRefresh: true),
                            popupItem: [
                              kPopupMakeAdmin,
                              kPopupRemoveMember,
                              kPopupBlock,
                              kPopupViewProfile,
                            ],
                            isAdminUser: provider.isAdmin,
                          );
                        } else if (provider.canLoadMore) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return Container();
                        }
                      },
                    );
                  }
                },
              )
            ],
          );
        },
      ),
    );
  }
}
