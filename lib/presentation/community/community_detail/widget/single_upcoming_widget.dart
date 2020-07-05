import 'package:flutter/material.dart';
import 'package:localin/components/custom_image_only_radius.dart';
import 'package:localin/model/community/community_detail.dart';
import 'package:localin/model/community/community_event_response_model.dart';
import 'package:localin/presentation/community/community_event/community_event_detail_page.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';

class SingleUpcomingWidget extends StatelessWidget {
  final EventResponseData event;
  final int index;
  SingleUpcomingWidget({this.event, this.index});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: index == 0 ? 20.0 : 6.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          InkWell(
            onTap: () {
              CommunityDetail cDetail = CommunityDetail(
                  id: event.communityId,
                  slug: event.communitySlug,
                  joinStatus: event.communityJoinStatus,
                  name: event.communityName,
                  logo: event.communityLogo);
              Navigator.of(context)
                  .pushNamed(CommunityEventDetailPage.routeName, arguments: {
                CommunityEventDetailPage.eventSlug: event.id,
                CommunityEventDetailPage.communityData: cDetail,
              });
            },
            child: CustomImageOnlyRadius(
              imageUrl: event?.attachment?.first?.attachment ?? '',
              width: double.maxFinite,
              height: 157.0,
              topRight: 8.0,
              topLeft: 8.0,
              placeHolderColor: ThemeColors.black100,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: ThemeColors.black0,
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(8.0),
                    bottomLeft: Radius.circular(8.0))),
            padding: EdgeInsets.only(top: 16.0),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 12.0, right: 12.0),
                    padding:
                        EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
                    decoration: BoxDecoration(
                        color: ThemeColors.black10,
                        borderRadius: BorderRadius.circular(8.0)),
                    child: Column(
                      children: <Widget>[
                        Text(
                          '${event.startDate.month.monthCharacter}',
                          style: ThemeText.sfSemiBoldFootnote
                              .copyWith(color: ThemeColors.black80),
                        ),
                        Text(
                          '${event.startDate.day}',
                          style: ThemeText.sfSemiBoldTitle3
                              .copyWith(color: ThemeColors.orange),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(right: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '${event?.title}',
                            maxLines: 2,
                            style: ThemeText.sfRegularHeadline,
                          ),
                          Visibility(
                            visible: event.address.isNotEmpty,
                            child: Text(
                              '${event?.address}',
                              maxLines: 2,
                              style: ThemeText.sfRegularBody
                                  .copyWith(color: ThemeColors.black80),
                            ),
                          ),
                          SizedBox(
                            height: 2.0,
                          ),
                          Text('${event?.startTime} - ${event?.endTime}',
                              style: ThemeText.sfRegularBody
                                  .copyWith(color: ThemeColors.black80)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

extension on int {
  String get monthCharacter {
    switch (this) {
      case 1:
        return 'January';
        break;
      case 2:
        return 'February';
        break;
      case 3:
        return 'March';
        break;
      case 4:
        return 'April';
        break;
      case 5:
        return 'May';
        break;
      case 6:
        return 'June';
        break;
      case 7:
        return 'July';
        break;
      case 8:
        return 'August';
        break;
      case 9:
        return 'September';
        break;
      case 10:
        return 'October';
        break;
      case 11:
        return 'November';
        break;
      case 12:
        return 'December';
        break;
    }
    return '';
  }
}
