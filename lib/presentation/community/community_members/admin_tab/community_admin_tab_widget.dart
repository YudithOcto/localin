import 'package:flutter/material.dart';
import 'package:localin/presentation/community/community_members/admin_tab/community_admin_tab_provider.dart';
import 'package:localin/presentation/community/community_members/shared_members_widget/enum_members.dart';
import 'package:localin/presentation/community/community_members/shared_members_widget/single_member_widget.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

class CommunityAdminTabWidget extends StatefulWidget {
  @override
  _CommunityAdminTabWidgetState createState() =>
      _CommunityAdminTabWidgetState();
}

class _CommunityAdminTabWidgetState extends State<CommunityAdminTabWidget> {
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<CommunityAdminTabProvider>(context, listen: false)
          .getAdminCommunity();
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
                Provider.of<CommunityAdminTabProvider>(context, listen: false)
                    .adminStream,
            builder: (context, snapshot) {
              final provider = Provider.of<CommunityAdminTabProvider>(context,
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
                  itemCount: provider.adminList.length + 1,
                  itemBuilder: (context, index) {
                    if (snapshot.data == communityMemberState.empty) {
                      return Container(
                        child: Text(
                          'No Admin',
                          style: ThemeText.rodinaTitle3,
                        ),
                      );
                    } else if (index < provider.adminList.length) {
                      final item = provider.adminList[index];
                      return SingleMemberWidget(
                        detail: item,
                        isGroupCreator: index == 0,
                        popupItem: [
                          'Remove Admin',
                          'Remove Member',
                          'Block',
                          'View Profile',
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
