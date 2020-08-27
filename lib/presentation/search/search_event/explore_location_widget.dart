import 'package:flutter/material.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';

class ExploreLocationWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final String category;
  final VoidCallback onTap;

  ExploreLocationWidget({this.title, this.subtitle, this.category, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ListTile(
        title: Text(
          title,
          style: ThemeText.rodinaHeadline,
        ),
        subtitle: Visibility(
          visible: subtitle != null && subtitle.isNotEmpty,
          child: Text(
            subtitle ?? '',
            style:
                ThemeText.sfMediumFootnote.copyWith(color: ThemeColors.black80),
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.0),
              border: Border.all(color: ThemeColors.primaryBlue)),
          child: Text(
            category ?? '',
            style: ThemeText.sfMediumCaption
                .copyWith(color: ThemeColors.primaryBlue),
          ),
        ),
      ),
    );
  }
}
