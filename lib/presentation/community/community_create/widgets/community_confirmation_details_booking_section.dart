import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localin/presentation/community/provider/create/community_type_provider.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

import 'community_confirmation_details_widget.dart';

class ConfirmationDetailsBookingSection extends StatelessWidget {
  final String communityName;

  ConfirmationDetailsBookingSection({@required this.communityName});

  @override
  Widget build(BuildContext context) {
    return Consumer<CommunityTypeProvider>(
      builder: (_, provider, __) {
        return Container(
          color: ThemeColors.black0,
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text('Community',
                  style: ThemeText.sfMediumFootnote
                      .copyWith(color: ThemeColors.black80)),
              SizedBox(height: 3.0),
              Text(communityName, style: ThemeText.sfRegularHeadline),
              SizedBox(height: 12.0),
              SingleRowDetail(
                title: 'Type',
                value: buildValueTextWithoutIcon(
                    provider?.communityTypeRequestModel?.communityType ?? ''),
              ),
              SingleRowDetail(
                title: 'Until',
                value: buildValueTextWithIcon(
                    provider?.communityTypeRequestModel?.until ?? ''),
              ),
              SingleRowDetail(
                title: 'Duration',
                value: buildValueTextWithoutIcon(
                    provider?.communityTypeRequestModel?.duration ?? ''),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildValueTextWithoutIcon(String text) {
    return Text(text, style: ThemeText.sfMediumFootnote);
  }

  Widget buildValueTextWithIcon(String text) {
    return Row(
      children: <Widget>[
        SvgPicture.asset('images/calendar.svg'),
        SizedBox(width: 10.0),
        buildValueTextWithoutIcon(text),
      ],
    );
  }
}
