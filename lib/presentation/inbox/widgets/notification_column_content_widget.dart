import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localin/components/custom_dialog.dart';
import 'package:localin/model/notification/notification_model.dart';
import 'package:localin/presentation/inbox/widgets/empty_inbox_widget.dart';
import 'package:localin/presentation/inbox/widgets/single_card_notification.dart';
import 'package:localin/provider/notification/notification_provider.dart';
import 'package:localin/text_themes.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import '../../../themes.dart';

class NotificationColumnContentWidget extends StatefulWidget {
  final ValueChanged<int> valueChanged;
  NotificationColumnContentWidget({this.valueChanged});
  @override
  _NotificationColumnContentWidgetState createState() =>
      _NotificationColumnContentWidgetState();
}

class _NotificationColumnContentWidgetState
    extends State<NotificationColumnContentWidget> {
  ScrollController _scrollController;
  bool isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isInit) {
      Provider.of<NotificationProvider>(context, listen: false)
          .getNotificationList(isRefresh: true);
      isInit = false;
    }
  }

  _notificationScrollListener() {
    if (_scrollController.offset >=
        _scrollController.position.maxScrollExtent) {
      Provider.of<NotificationProvider>(context, listen: false)
          .getNotificationList();
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController..addListener(_notificationScrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          color: ThemeColors.black0,
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Inbox',
                style: ThemeText.rodinaTitle1,
              ),
              Row(
                children: <Widget>[
                  Consumer<NotificationProvider>(
                    builder: (context, notificationProvider, child) {
                      return Text(
                        '${notificationProvider.totalInbox} inbox',
                        style: ThemeText.sfSemiBoldBody,
                      );
                    },
                  ),
                  SizedBox(
                    width: 13.0,
                  ),
                  InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext ctx) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0)),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    'Delete All?',
                                    style: ThemeText.sfMediumTitle3,
                                  ),
                                  SizedBox(height: 8.0),
                                  Text(
                                      'Once you delete all inbox, you can\'t undo it.',
                                      style: ThemeText.sfMediumBody.copyWith(
                                          color: ThemeColors.black80)),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: RaisedButton(
                                          elevation: 1.0,
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                          color: ThemeColors.primaryBlue,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                          ),
                                          child: Text(
                                            'Cancel',
                                            style: ThemeText.rodinaTitle3
                                                .copyWith(
                                                    color: ThemeColors.black0),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 7.0,
                                      ),
                                      Expanded(
                                        child: RaisedButton(
                                          elevation: 1.0,
                                          color: ThemeColors.black0,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4.0),
                                              side: BorderSide(
                                                color: ThemeColors.primaryBlue,
                                              )),
                                          onPressed: () async {
                                            final response = await Provider.of<
                                                        NotificationProvider>(
                                                    context,
                                                    listen: false)
                                                .deleteAllNotification();
                                            if (response != null) {
                                              Provider.of<NotificationProvider>(
                                                      context,
                                                      listen: false)
                                                  .getNotificationList(
                                                      isRefresh: true);
                                            }
                                            Navigator.of(context).pop();
                                          },
                                          child: Text(
                                            'Delete All',
                                            style: ThemeText.rodinaTitle3
                                                .copyWith(
                                                    color: ThemeColors
                                                        .primaryBlue),
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            );
                          });
                    },
                    child: SvgPicture.asset(
                      'images/trash.svg',
                      width: 15.46,
                      height: 16.93,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        StreamBuilder<NotificationState>(
          stream: Provider.of<NotificationProvider>(context)
              .notificationStateStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting &&
                Provider.of<NotificationProvider>(context).offsetPageRequest <=
                    1) {
              return Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.3),
                child: CircularProgressIndicator(),
              );
            }
            return Expanded(
              child: Consumer<NotificationProvider>(
                builder: (context, notifProvider, child) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      notifProvider.getNotificationList(isRefresh: true);
                    },
                    child: ListView.separated(
                      separatorBuilder: (context, index) {
                        return Container(
                          width: double.maxFinite,
                          height: 1.0,
                          color: ThemeColors.black10,
                        );
                      },
                      physics: ClampingScrollPhysics(),
                      controller: _scrollController,
                      itemCount: notifProvider.notificationList.length + 1,
                      itemBuilder: (context, index) {
                        if (snapshot.data == NotificationState.NoData) {
                          return EmptyInboxWidget(
                              valueChanged: widget.valueChanged);
                        } else if (index <
                            notifProvider.notificationList.length) {
                          return Dismissible(
                            direction: DismissDirection.endToStart,
                            background: stackBehindDismiss(),
                            key: Key(notifProvider.notificationList[index].id +
                                notifProvider.notificationList.length
                                    .toString()),
                            child: SingleCardNotification(
                              detailModel:
                                  notifProvider.notificationList[index],
                            ),
                            onDismissed: (direction) async {
                              final tempSelectedIndex = index;
                              final tempItem =
                                  notifProvider.notificationList[index];
                              CustomDialog.showLoadingDialog(context);
                              final result =
                                  await notifProvider.deleteNotificationById(
                                      notifProvider.notificationList[index].id);
                              notifProvider.deleteItem(index);
                              CustomDialog.closeDialog(context);
                              showToastMessage(
                                  notifProvider, tempItem, tempSelectedIndex);
                            },
                          );
                        } else if (notifProvider.isCanLoadMore) {
                          return Center(child: CircularProgressIndicator());
                        } else {
                          return Container();
                        }
                      },
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  showToastMessage(NotificationProvider notifProvider,
      NotificationDetailModel tempItem, int index,
      {bool isFailed = false}) async {
    showToastWidget(
      Container(
        padding: EdgeInsets.symmetric(horizontal: 30.0),
        child: Material(
          shadowColor: ThemeColors.black80,
          elevation: 1,
          color: ThemeColors.black0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
          child: Container(
            height: 60.0,
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SvgPicture.asset(
                      'images/trash.svg',
                      width: 15.46,
                      height: 16.93,
                    ),
                    SizedBox(
                      width: 11.0,
                    ),
                    Text(
                      isFailed
                          ? "Failed to delete message "
                          : 'Message deleted',
                      style: ThemeText.sfSemiBoldBody,
                    ),
                  ],
                ),
                isFailed
                    ? Container()
                    : InkWell(
                        onTap: () async {
                          await notifProvider
                              .unDeleteNotificationId(tempItem.id);
                          notifProvider.undoDeleteItem(index, tempItem);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Undo',
                            style: ThemeText.sfSemiBoldBody
                                .copyWith(color: ThemeColors.primaryBlue),
                          ),
                        ),
                      )
              ],
            ),
          ),
        ),
      ),
      animationBuilder: Miui10AnimBuilder(),
      animationDuration: Duration(milliseconds: 100),
      textDirection: TextDirection.ltr,
      duration: Duration(seconds: 5),
      animationCurve: Curves.easeIn,
      context: context,
      position: ToastPosition(offset: -90, align: Alignment.bottomCenter),
      handleTouch: true,
      dismissOtherToast: true,
    );
  }

  Widget stackBehindDismiss() {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 20.0),
      color: Colors.red,
      child: Icon(
        Icons.delete,
        color: Colors.white,
      ),
    );
  }
}
