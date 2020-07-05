import 'package:flutter/material.dart';
import 'package:localin/presentation/community/community_event/provider/community_event_detail_provider.dart';
import 'package:localin/presentation/community/community_event/widgets/community_event_detail_attendees_widget.dart';
import 'package:localin/presentation/community/community_event/widgets/community_event_detail_description_widget.dart';
import 'package:localin/presentation/community/community_event/widgets/community_event_detail_location_widget.dart';
import 'package:localin/presentation/community/community_event/widgets/community_event_detail_top_header_join_info_widget.dart';
import 'package:localin/presentation/community/community_event/widgets/community_event_detail_upper_content_widget.dart';
import 'package:provider/provider.dart';

import 'community_event_detail_image_carousel_widget.dart';

class CommunityEventDetailWrapperWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CommunityEventDetailProvider>(
      builder: (context, provider, child) {
        return SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 42.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CommunityEventDetailTopHeaderJoinInfoWidget(),
              CommunityEventDetailImageCarouselWidget(),
              CommunityEventDetailDescriptionWidget(),
              CommunityEventDetailUpperContentWidget(),
              CommunityEventDetailAttendeesWidget(),
              CommunityEventDetailLocationWidget(),
            ],
          ),
        );
      },
    );
  }
}
