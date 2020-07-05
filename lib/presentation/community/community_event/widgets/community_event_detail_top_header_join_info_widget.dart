import 'package:flutter/material.dart';
import 'package:localin/presentation/community/community_event/provider/community_event_detail_provider.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

class CommunityEventDetailTopHeaderJoinInfoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CommunityEventDetailProvider>(
      builder: (context, provider, child) {
        return Visibility(
          visible: !provider.eventResponse.userAttendStatus
              .toLowerCase()
              .contains('have not joined'),
          child: Container(
            width: double.maxFinite,
            color: provider
                .eventResponse.userAttendStatus.backgroundColorEventStatus,
            alignment: FractionalOffset.center,
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              '${provider.eventResponse.userAttendStatus}',
              style: ThemeText.sfMediumFootnote
                  .copyWith(color: ThemeColors.black0),
            ),
          ),
        );
      },
    );
  }
}

extension on String {
  Color get backgroundColorEventStatus {
    print(this);
    if (this.toLowerCase().contains('canceled')) {
      return ThemeColors.black100;
    } else if (this.toLowerCase().contains('going')) {
      return ThemeColors.green;
    } else if (this.toLowerCase().contains('tentative')) {
      return ThemeColors.orange;
    } else if (this.toLowerCase().contains('canceling')) {
      return ThemeColors.red;
    } else if (this.toLowerCase().contains('waiting')) {
      return ThemeColors.primaryBlue;
    } else {
      return ThemeColors.green;
    }
  }
}
