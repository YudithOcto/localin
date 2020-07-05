import 'package:flutter/material.dart';
import 'package:localin/components/user_profile_box_widget.dart';
import 'package:localin/presentation/community/community_event/provider/community_event_detail_provider.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

class CommunityEventDetailDescriptionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CommunityEventDetailProvider>(
      builder: (context, provider, child) {
        return Container(
          width: double.infinity,
          color: ThemeColors.black0,
          padding: const EdgeInsets.only(
              top: 18.0, left: 20.0, right: 20.0, bottom: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '${provider.eventResponse.title}',
                style: ThemeText.rodinaTitle2,
              ),
              SizedBox(
                height: 18.0,
              ),
              Row(
                children: <Widget>[
                  UserProfileImageWidget(
                    imageUrl: provider.eventResponse.createdImageProfile,
                    width: 45.0,
                    height: 45.0,
                    isVerifyUser: provider.eventResponse.isVerifyCreator,
                  ),
                  SizedBox(
                    width: 15.0,
                  ),
                  RichText(
                    text: TextSpan(children: <TextSpan>[
                      TextSpan(
                          text: 'Hosted by',
                          style: ThemeText.sfRegularFootnote
                              .copyWith(color: ThemeColors.black80)),
                      TextSpan(
                          text: '\n${provider.eventResponse?.createdName}',
                          style: ThemeText.rodinaHeadline
                              .copyWith(color: ThemeColors.primaryBlue)),
                    ]),
                  )
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
