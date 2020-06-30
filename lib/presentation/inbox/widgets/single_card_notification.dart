import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localin/model/notification/notification_model.dart';
import 'package:localin/presentation/community/community_detail/community_detail_page.dart';
import 'package:localin/presentation/hotel/booking_detail_page.dart';
import 'package:localin/presentation/news/pages/news_detail_page.dart';
import 'package:localin/provider/notification/notification_provider.dart';
import 'package:localin/themes.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/utils/date_helper.dart';
import 'package:provider/provider.dart';

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
                .pushNamed(NewsDetailPage.routeName, arguments: {
              NewsDetailPage.newsSlug: detailModel?.typeId,
            });
            break;
          case 'komunitas':
            Navigator.of(context)
                .pushNamed(CommunityDetailPage.routeName, arguments: {
              CommunityDetailPage.communityData: detailModel,
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
                  SizedBox(
                    height: 4.0,
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
