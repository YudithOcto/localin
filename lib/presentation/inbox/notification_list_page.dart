import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localin/components/filled_button_default.dart';
import 'package:localin/components/outline_button_default.dart';
import 'package:localin/model/notification/notification_model.dart';
import 'package:localin/presentation/article/pages/article_detail_page.dart';
import 'package:localin/presentation/community/pages/community_detail_page.dart';
import 'package:localin/presentation/hotel/booking_detail_page.dart';
import 'package:localin/provider/notification/notification_provider.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:localin/utils/date_helper.dart';
import 'package:provider/provider.dart';

class NotificationListPage extends StatefulWidget {
  static const routeName = 'notificationListPage';

  @override
  _NotificationListPageState createState() => _NotificationListPageState();
}

class _NotificationListPageState extends State<NotificationListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.black10,
      body: ChangeNotifierProvider<NotificationProvider>(
        create: (_) => NotificationProvider(),
        child: SafeArea(child: ColumnContent()),
      ),
    );
  }
}

class ColumnContent extends StatelessWidget {
  final int pageSize = 10;

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
                  Text('120 inbox'),
                  SizedBox(
                    width: 13.0,
                  ),
                  InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0)),
                              title: Text(
                                'Delete All?',
                                style: ThemeText.sfMediumTitle3,
                              ),
                              content: Text(
                                  'Once you delete all inbox, you can\'t undo it.',
                                  style: ThemeText.sfMediumBody
                                      .copyWith(color: ThemeColors.black80)),
                              actions: <Widget>[
                                RaisedButton(
                                  elevation: 1.0,
                                  color: ThemeColors.black0,
                                  onPressed: () => Navigator.of(context).pop(),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4.0),
                                      side: BorderSide(
                                        color: ThemeColors.primaryBlue,
                                      )),
                                  child: Text(
                                    'Cancel',
                                    style: ThemeText.rodinaTitle3.copyWith(
                                        color: ThemeColors.primaryBlue),
                                  ),
                                ),
                                RaisedButton(
                                  elevation: 1.0,
                                  color: ThemeColors.primaryBlue,
                                  onPressed: () {
                                    showToastWidget(
                                        Container(
                                          height: 60.0,
                                          width: 288.0,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20.0),
                                          decoration: BoxDecoration(
                                            color: ThemeColors.black0,
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                          ),
                                          alignment: Alignment.center,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
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
                                                    'Message deleted',
                                                    style: ThemeText
                                                        .sfSemiBoldBody,
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                'Undo',
                                                style: ThemeText.sfSemiBoldBody
                                                    .copyWith(
                                                        color: ThemeColors
                                                            .primaryBlue),
                                              )
                                            ],
                                          ),
                                        ),
                                        position: StyledToastPosition(
                                            offset: 70.0,
                                            align: Alignment.bottomCenter),
                                        context: context, onDismiss: () {
                                      //should be calling api here
                                      print('DISMISSED');
                                    });
                                  },
                                  child: Text(
                                    'Delete All',
                                    style: ThemeText.rodinaTitle3
                                        .copyWith(color: Colors.white),
                                  ),
                                )
                              ],
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
        Flexible(
          child: PagewiseListView(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            pageSize: pageSize,
            itemBuilder: (context, item, index) {
              return SingleCardNotification(
                detailModel: item,
              );
            },
            noItemsFoundBuilder: (context) => EmptyInboxWidget(),
            showRetry: false,
            pageFuture: (pageIndex) {
              return Provider.of<NotificationProvider>(context)
                  .getNotificationList(pageIndex + 1, pageSize);
            },
          ),
        )
      ],
    );
  }
}

class SingleCardNotification extends StatelessWidget {
  final NotificationDetailModel detailModel;
  SingleCardNotification({this.detailModel});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        Provider.of<NotificationProvider>(context, listen: false)
            .updateReadNotification(detailModel.id);
        switch (detailModel?.type) {
          case 'hotel':
            Navigator.of(context).pushNamed(BookingDetailPage.routeName,
                arguments: {BookingDetailPage.bookingId: detailModel?.typeId});
            break;
          case 'artikel':
            Navigator.of(context)
                .pushNamed(ArticleDetailPage.routeName, arguments: {
              ArticleDetailPage.articleId: detailModel?.typeId,
              ArticleDetailPage.commentPage: false
            });
            break;
          case 'komunitas':
            Navigator.of(context).pushNamed(CommunityDetailPage.routeName,
                arguments: {
                  CommunityDetailPage.communitySlug: detailModel?.typeId
                });
            break;
        }
      },
      child: Container(
        color:
            detailModel.isRead == 0 ? ThemeColors.yellow10 : ThemeColors.black0,
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            detailModel.isRead == 0
                ? Image.asset('images/inbox_unread.png')
                : SvgPicture.asset('images/Inbox.svg'),
            SizedBox(
              width: 16.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '${DateHelper.formatDateBookingDetail(detailModel?.createdAt)}',
                    textAlign: TextAlign.center,
                    style: ThemeText.sfMediumCaption
                        .copyWith(color: ThemeColors.brandBlack),
                  ),
                  Text(
                    '${detailModel?.message}',
                    style: ThemeText.sfSemiBoldHeadline
                        .copyWith(color: ThemeColors.black100),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class EmptyInboxWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: ThemeColors.black10,
      width: double.infinity,
      height: MediaQuery.of(context).size.height * .7,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(child: SvgPicture.asset('images/inbox_empty.svg')),
          Container(
            margin: EdgeInsets.only(top: 18.0, bottom: 4.0),
            child: Text(
              'Can\'t find notification',
              style: ThemeText.sfSemiBoldHeadline
                  .copyWith(color: ThemeColors.black80),
            ),
          ),
          Text(
            'Let\'s explore more content around you.',
            style: ThemeText.sfRegularBody.copyWith(color: ThemeColors.black80),
          ),
          SizedBox(
            height: 35.0,
          ),
          OutlineButtonDefault(
            width: 240.0,
            buttonText: 'Back to Feed',
            onPressed: () {},
            backgroundColor: ThemeColors.black10,
          )
        ],
      ),
    );
  }
}
