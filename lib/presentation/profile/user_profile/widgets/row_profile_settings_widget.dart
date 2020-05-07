import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../text_themes.dart';
import '../../../../themes.dart';

class RowProfileSettingsWidget extends StatelessWidget {
  final Function onPressed;
  final bool showButton;
  final String iconValue;
  final String title;
  final String description;
  final bool isButtonActivated;

  RowProfileSettingsWidget({
    @required this.onPressed,
    @required this.iconValue,
    @required this.title,
    @required this.description,
    this.showButton = false,
    this.isButtonActivated = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SvgPicture.asset(
            iconValue,
            fit: BoxFit.cover,
          ),
          SizedBox(
            width: 16.0,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '$title',
                  style: ThemeText.sfMediumBody,
                ),
                SizedBox(
                  height: 2.0,
                ),
                Text(
                  '$description',
                  style: ThemeText.sfRegularBody
                      .copyWith(color: ThemeColors.black80),
                ),
              ],
            ),
          ),
          Visibility(
            visible: showButton,
            child: Container(
              margin: EdgeInsets.only(right: 15.0),
              decoration: BoxDecoration(
                  color: ThemeColors.green10,
                  borderRadius: BorderRadius.circular(4.0)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  isButtonActivated ? 'Connected' : 'Not Verified',
                  style: ThemeText.sfMediumFootnote
                      .copyWith(color: ThemeColors.green80),
                ),
              ),
            ),
          ),
          Icon(
            Icons.navigate_next,
            size: 30.0,
            color: ThemeColors.black60,
          ),
        ],
      ),
    );
  }
}
