import 'package:flutter/material.dart';
import 'package:localin/presentation/community/community_members/blocked_tab/community_blocked_tab_provider.dart';
import 'package:localin/presentation/community/community_members/shared_members_widget/custom_member_text_form_field_widget.dart';
import 'package:localin/presentation/community/community_members/shared_members_widget/enum_members.dart';
import 'package:localin/presentation/community/community_members/shared_members_widget/single_member_widget.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:localin/utils/constants.dart';
import 'package:localin/utils/date_helper.dart';
import 'package:localin/utils/debounce.dart';
import 'package:provider/provider.dart';

class CommunityBlockedTabWidget extends StatefulWidget {
  @override
  _CommunityBlockedTabWidgetState createState() =>
      _CommunityBlockedTabWidgetState();
}

class _CommunityBlockedTabWidgetState extends State<CommunityBlockedTabWidget> {
  bool _isInit = true;
  final _scrollController = ScrollController();
  final _debounce = Debounce(milliseconds: 400);

  @override
  void didChangeDependencies() {
    if (_isInit) {
      loadData();
      _scrollController.addListener(() {
        if (_scrollController.offset >
            _scrollController.position.maxScrollExtent) {
          loadData(isRefresh: false);
        }
      });
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  loadData({bool isRefresh = true}) {
    Provider.of<CommunityBlockedTabProvider>(context, listen: false)
        .getBlockedUser(isRefresh: isRefresh);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: <Widget>[
          CustomMemberTextFormFieldWidget(
            onChange: (v) {
              _debounce.run(() => Provider.of<CommunityBlockedTabProvider>(
                      context,
                      listen: false)
                  .requestSearchKeyword = v);
            },
          ),
          StreamBuilder<communityMemberState>(
            stream:
                Provider.of<CommunityBlockedTabProvider>(context, listen: false)
                    .blockedStream,
            builder: (context, snapshot) {
              final provider = Provider.of<CommunityBlockedTabProvider>(context,
                  listen: false);
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
                  itemCount: provider.blockedList.length + 1,
                  itemBuilder: (context, index) {
                    if (snapshot.data == communityMemberState.empty) {
                      return Container(
                        child: Text(
                          'No BlockedUser',
                          style: ThemeText.rodinaTitle3,
                        ),
                      );
                    } else if (index < provider.blockedList.length) {
                      final item = provider.blockedList[index];
                      return SingleMemberWidget(
                        isOnlyAdminTab: false,
                        detail: item,
                        rowDescription:
                            'Blocked by ${item.name} ${DateHelper.timeAgo(DateTime.parse(item.joinedDate))}',
                        onRefresh: () => provider.getBlockedUser(),
                        popupItem: [
                          kPopupRemoveBlock,
                          kPopupRemoveMember,
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
      ),
    );
  }
}
