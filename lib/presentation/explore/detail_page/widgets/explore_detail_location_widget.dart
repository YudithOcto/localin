import 'package:flutter/material.dart';
import 'package:localin/components/custom_image_radius.dart';
import 'package:localin/presentation/explore/detail_page/provider/explore_event_detail_provider.dart';
import 'package:localin/text_themes.dart';
import 'package:provider/provider.dart';

class ExploreDetailLocationWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ExploreEventDetailProvider>(context);
    return Container(
      margin: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Location',
            style: ThemeText.sfSemiBoldHeadline,
          ),
          SizedBox(height: 8.0),
          CustomImageRadius(
            width: double.maxFinite,
            height: 179.0,
            radius: 8.0,
          ),
          SizedBox(height: 12.0),
          Text(
            '${provider.eventDetail.schedules[0]?.location?.address}',
            style: ThemeText.sfRegularBody,
          )
        ],
      ),
    );
  }
}
