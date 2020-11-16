import 'package:flutter/material.dart';
import 'package:localin/components/custom_image_radius.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';

class EventTileWidget extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;

  EventTileWidget({this.imageUrl, this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Visibility(
        visible: imageUrl != null,
        child: CustomImageRadius(
          radius: 8.0,
          imageUrl: imageUrl ?? '',
        ),
      ),
      title: Text(title, style: ThemeText.rodinaHeadline),
      subtitle: Text(
        subtitle,
        style: ThemeText.sfMediumFootnote.copyWith(color: ThemeColors.black80),
      ),
    );
  }
}
