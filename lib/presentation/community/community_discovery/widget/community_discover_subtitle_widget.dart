import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localin/text_themes.dart';

class CommunityDiscoverSubtitleWidget extends StatelessWidget {
  final String svgAsset;
  final String title;
  CommunityDiscoverSubtitleWidget(
      {@required this.svgAsset, @required this.title});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SvgPicture.asset(svgAsset),
        SizedBox(
          width: 5.67,
        ),
        Text(
          title,
          style: ThemeText.sfSemiBoldHeadline,
        )
      ],
    );
  }
}
