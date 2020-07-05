import 'package:flutter/material.dart';
import 'package:localin/presentation/community/community_event/community_event_member_page.dart';
import 'package:localin/presentation/community/community_event/enums.dart';
import 'package:localin/presentation/community/community_event/widgets/member_going/community_event_going_member_provider.dart';
import 'package:localin/presentation/community/community_members/shared_members_widget/custom_member_text_form_field_widget.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/utils/debounce.dart';
import 'package:provider/provider.dart';

import '../community_member_widget.dart';

class CommunityMemberListWidget extends StatefulWidget {
  @override
  _CommunityMemberListWidgetState createState() =>
      _CommunityMemberListWidgetState();
}

class _CommunityMemberListWidgetState extends State<CommunityMemberListWidget> {
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
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    final eventId = routeArgs[CommunityEventMemberPage.eventId] ?? '';
    Provider.of<CommunityEventGoingMemberProvider>(context, listen: false)
        .getMemberOnGoing(eventId, isRefresh: isRefresh);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: <Widget>[
          CustomMemberTextFormFieldWidget(onChange: (v) {
            _debounce.run(() {
              //provider.requestSearchKeyword = v;
            });
          }),
          Consumer<CommunityEventGoingMemberProvider>(
            builder: (context, provider, child) {
              return StreamBuilder<eventMemberState>(
                stream: provider.eventMemberStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting &&
                      provider.pageRequest <= 1) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return ListView.builder(
                      physics: ClampingScrollPhysics(),
                      shrinkWrap: true,
                      controller: _scrollController,
                      itemCount: provider.memberListDetail.length + 1,
                      itemBuilder: (context, index) {
                        if (snapshot.data == eventMemberState.empty) {
                          return Container(
                            child: Text(
                              'No Member',
                              textAlign: TextAlign.center,
                              style: ThemeText.rodinaTitle3,
                            ),
                          );
                        } else if (index < provider.memberListDetail.length) {
                          final item = provider.memberListDetail[index];
                          return CommunityMemberWidget(
                            detail: item,
                          );
                        } else if (provider.isOngoingMemberCanLoadMore) {
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
              );
            },
          )
        ],
      ),
    );
  }
}
