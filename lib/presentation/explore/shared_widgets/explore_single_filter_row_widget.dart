import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';

class ExploreSingleFilterRowWidget extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onPressed;
  ExploreSingleFilterRowWidget(
      {@required this.title, this.isSelected, this.onPressed});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
        color: ThemeColors.black0,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              '$title',
              style: ThemeText.sfRegularBody,
            ),
            SvgPicture.asset(
                'images/${isSelected ? 'checkbox_checked_blue' : 'checkbox_uncheck'}.svg'),
          ],
        ),
      ),
    );
  }
}
