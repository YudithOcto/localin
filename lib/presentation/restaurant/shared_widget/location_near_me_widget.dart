import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:localin/utils/constants.dart';

class LocationNearMeWidget extends StatelessWidget {
  final String title;

  LocationNearMeWidget({this.title = 'Restaurant Near Me'});

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      highlightColor: ThemeColors.primaryBlue,
      onTap: () {
        Navigator.of(context).pop(kNearby);
      },
      child: Container(
        padding: const EdgeInsets.all(21.0),
        color: ThemeColors.black0,
        child: Row(
          children: <Widget>[
            SvgPicture.asset('images/location_icon_grey.svg'),
            SizedBox(width: 12.0),
            Text(
              '$title',
              style: ThemeText.rodinaHeadline
                  .copyWith(color: ThemeColors.primaryBlue),
            )
          ],
        ),
      ),
    );
  }
}
