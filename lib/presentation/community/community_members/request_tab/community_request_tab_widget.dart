import 'package:flutter/material.dart';
import 'package:localin/components/filled_button_default.dart';
import 'package:localin/components/outline_button_default.dart';
import 'package:localin/presentation/community/community_members/request_tab/community_request_tab_provider.dart';
import 'package:localin/presentation/community/community_members/shared_members_widget/custom_member_text_form_field_widget.dart';
import 'package:localin/presentation/community/community_members/shared_members_widget/enum_members.dart';
import 'package:localin/presentation/community/community_members/shared_members_widget/single_member_widget.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:localin/utils/constants.dart';
import 'package:localin/utils/date_helper.dart';
import 'package:localin/utils/debounce.dart';
import 'package:provider/provider.dart';

class CommunityRequestTabWidget extends StatefulWidget {
  @override
  _CommunityRequestTabWidgetState createState() =>
      _CommunityRequestTabWidgetState();
}

class _CommunityRequestTabWidgetState extends State<CommunityRequestTabWidget> {
  bool _isInit = true;
  Debounce _debounce = Debounce(milliseconds: 300);
  final _scrollController = ScrollController();

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<CommunityRequestTabProvider>(context, listen: false)
          .getRequestList();
      _scrollController..addListener(_listener);
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  _listener() {
    if (_scrollController.offset > _scrollController.position.maxScrollExtent) {
      Provider.of<CommunityRequestTabProvider>(context, listen: false)
          .getRequestList(isRefresh: false);
    }
  }

  showSortingDialog() {
    final provider =
        Provider.of<CommunityRequestTabProvider>(context, listen: false);
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          provider.sortingList.length,
          (index) {
            return InkWell(
              onTap: () {
                provider.selectSort = provider.sortingList[index];
                Navigator.of(context).pop();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '${provider.sortingList[index]}',
                    style: ThemeText.sfMediumHeadline,
                  ),
                  Radio(
                    value: provider.sortingList[index],
                    activeColor: ThemeColors.black80,
                    groupValue: provider.selectedSort,
                    onChanged: (category) {
                      provider.selectSort = category;
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: <Widget>[
          CustomMemberTextFormFieldWidget(
            onChange: (v) {
              _debounce.run(() {
                Provider.of<CommunityRequestTabProvider>(context, listen: false)
                    .requestSearchKeyword = v;
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Consumer<CommunityRequestTabProvider>(
                builder: (context, provider, child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '${provider.requestList.length} matching request',
                        style: ThemeText.sfSemiBoldBody,
                      ),
                      SizedBox(
                        height: 2.0,
                      ),
                      Text(
                        '${provider.selectedSort}',
                        style: ThemeText.sfRegularFootnote
                            .copyWith(color: ThemeColors.black80),
                      )
                    ],
                  );
                },
              ),
              InkWell(
                onTap: () {
                  showGeneralDialog(
                      context: context,
                      barrierDismissible: true,
                      barrierLabel: MaterialLocalizations.of(context)
                          .modalBarrierDismissLabel,
                      transitionDuration: const Duration(milliseconds: 150),
                      barrierColor: ThemeColors.brandBlack.withOpacity(0.8),
                      pageBuilder: (context, anim1, anim2) =>
                          showSortingDialog());
                },
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: ThemeColors.black20),
                      borderRadius: BorderRadius.circular(4.0)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'SORT',
                      style: ThemeText.sfMediumFootnote
                          .copyWith(color: ThemeColors.primaryBlue),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 16.0,
          ),
          Divider(
            thickness: 1.5,
            color: ThemeColors.black20,
          ),
          SizedBox(
            height: 18.0,
          ),
          StreamBuilder<communityMemberState>(
            stream:
                Provider.of<CommunityRequestTabProvider>(context, listen: false)
                    .requestStream,
            builder: (context, snapshot) {
              final provider = Provider.of<CommunityRequestTabProvider>(context,
                  listen: false);
              if (snapshot.connectionState == ConnectionState.waiting &&
                  provider.currentPageRequest <= 1) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Expanded(
                  child: ListView.builder(
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    controller: _scrollController,
                    itemCount: provider.requestList.length + 1,
                    itemBuilder: (context, index) {
                      if (snapshot.data == communityMemberState.empty) {
                        return Container(
                          alignment: FractionalOffset.center,
                          child: Text(
                            'Empty Request',
                            style: ThemeText.rodinaTitle2,
                          ),
                        );
                      } else if (index < provider.requestList.length) {
                        final item = provider.requestList[index];
                        return SingleMemberWidget(
                          onRefresh: () => provider.getRequestList(),
                          isOnlyAdmin: provider.requestList.length == 1,
                          detail: item,
                          rowDescription:
                              'Requested ${DateHelper.timeAgo(DateTime.parse(item.joinedDate))}',
                          isRequestPage: true,
                        );
                      } else if (provider.canLoadMore) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                );
              }
            },
          ),
          Consumer<CommunityRequestTabProvider>(
            builder: (context, provider, child) {
              return Visibility(
                visible: provider.requestList.isNotEmpty,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: FilledButtonDefault(
                          buttonText: 'Approve All',
                          textTheme: ThemeText.rodinaTitle3
                              .copyWith(color: ThemeColors.black0),
                          backgroundColor: ThemeColors.primaryBlue,
                          onPressed: () {},
                        ),
                      ),
                      SizedBox(width: 11),
                      Expanded(
                        child: OutlineButtonDefault(
                            textStyle: ThemeText.rodinaTitle3,
                            textColor: ThemeColors.black80,
                            sideColor: ThemeColors.black80,
                            buttonText: 'Decline All',
                            onPressed: () {}),
                      )
                    ],
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _debounce.cancel();
    super.dispose();
  }
}
