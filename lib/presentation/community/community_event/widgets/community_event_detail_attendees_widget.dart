import 'package:flutter/material.dart';
import 'package:localin/components/outline_button_default.dart';
import 'package:localin/components/user_profile_box_widget.dart';
import 'package:localin/model/community/community_event_member_response.dart';
import 'package:localin/presentation/community/community_event/community_event_member_page.dart';
import 'package:localin/presentation/community/community_event/provider/community_event_detail_provider.dart';
import 'package:localin/presentation/shared_widgets/subtitle.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

class CommunityEventDetailAttendeesWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CommunityEventDetailProvider>(
      builder: (context, provider, child) {
        List<EventMemberDetail> item =
            provider.eventResponse.memberList.take(3).toList();
        return Visibility(
          visible: provider.eventResponse.memberList.isNotEmpty,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                    top: 27.0, bottom: 8.0, left: 20.0, right: 20.0),
                child: Subtitle(
                  title:
                      'Attendees (${provider.eventResponse.memberGoingCount})',
                ),
              ),
              Container(
                color: ThemeColors.black0,
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                child: Column(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(
                        item.length,
                        (index) {
                          return rowUser(
                              type: index == 0 ? 'Co-organizer' : 'Member',
                              isVerify: item[index].verifiedUser,
                              userName: item[index].memberName,
                              userImage: item[index].memberImage);
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    OutlineButtonDefault(
                      buttonText: 'See All',
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                            CommunityEventMemberPage.routeName,
                            arguments: {
                              CommunityEventMemberPage.eventId:
                                  provider.eventResponse.id
                            });
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  rowUser(
      {String userName,
      String userImage,
      String type = 'Member',
      bool isVerify = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 9.0),
      child: Row(
        children: <Widget>[
          UserProfileImageWidget(
            width: 45.0,
            height: 45.0,
            imageUrl: userImage,
            isVerifyUser: isVerify,
          ),
          SizedBox(
            width: 15.0,
          ),
          RichText(
            text: TextSpan(children: <TextSpan>[
              TextSpan(
                  text: '$userName',
                  style: ThemeText.rodinaHeadline
                      .copyWith(color: ThemeColors.primaryBlue)),
              TextSpan(
                  text: '\n$type',
                  style: ThemeText.sfRegularFootnote
                      .copyWith(color: ThemeColors.black80)),
            ]),
          )
        ],
      ),
    );
  }
}
