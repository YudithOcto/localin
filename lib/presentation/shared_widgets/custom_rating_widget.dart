import 'package:flutter/material.dart';
import 'package:localin/presentation/shared_widgets/star_rating_widget.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';

class CustomRatingWidget extends StatelessWidget {
  final String starRating;
  final String totalRating;

  CustomRatingWidget({@required this.starRating, @required this.totalRating});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ThemeColors.black0,
        border: Border.all(color: ThemeColors.black40, width: 1.5),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        child: Row(
          children: <Widget>[
            StarRating(
              starCount: 5,
              rating: starRating.parseRating,
              color: ThemeColors.yellow40,
            ),
            SizedBox(width: 9.0),
            Text('($totalRating)', style: ThemeText.sfRegularCaption)
          ],
        ),
      ),
    );
  }
}

extension on String {
  double get parseRating {
    if (this == null || this.isEmpty) return 0.0;
    return double.parse(this);
  }
}
