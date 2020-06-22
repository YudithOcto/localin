import 'package:flutter/material.dart';
import 'package:localin/presentation/community/community_members/blocked_tab/community_blocked_tab_provider.dart';
import 'package:localin/presentation/community/community_members/shared_members_widget/enum_members.dart';
import 'package:localin/presentation/community/community_members/shared_members_widget/single_member_widget.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:localin/utils/constants.dart';
import 'package:localin/utils/date_helper.dart';
import 'package:provider/provider.dart';

class CommunityBlockedTabWidget extends StatefulWidget {
  @override
  _CommunityBlockedTabWidgetState createState() =>
      _CommunityBlockedTabWidgetState();
}

class _CommunityBlockedTabWidgetState extends State<CommunityBlockedTabWidget> {
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<CommunityBlockedTabProvider>(context, listen: false)
          .getBlockedUser();
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 20.0,
          ),
          TextFormField(
            decoration: InputDecoration(
              filled: true,
              fillColor: ThemeColors.black10,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6.0),
                  borderSide: BorderSide(color: ThemeColors.black0)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6.0),
                  borderSide: BorderSide(color: ThemeColors.black0)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6.0),
                  borderSide: BorderSide(color: ThemeColors.black0)),
              hintText: 'Search by name',
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
              hintStyle:
                  ThemeText.sfRegularBody.copyWith(color: ThemeColors.black60),
            ),
          ),
          SizedBox(
            height: 20.0,
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
                        isOnlyAdmin: false,
                        detail: item,
                        rowDescription:
                            'Blocked by ${item.name} ${DateHelper.timeAgo(DateTime.parse(item.joinedDate))}',
                        onRefresh: () => provider.getBlockedUser(),
                        popupItem: [
                          kPopupRemoveBlock,
                          kPopupRemoveMember,
                          kPopupViewProfile,
                        ],
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
