import 'package:flutter/material.dart';
import 'package:localin/model/restaurant/restaurant_response_model.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:localin/utils/number_helper.dart';

class RestaurantBasicDetailWidget extends StatelessWidget {
  final RestaurantDetail restaurantDetail;

  RestaurantBasicDetailWidget({@required this.restaurantDetail});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '${restaurantDetail.higlights.joinString}',
          style:
              ThemeText.sfMediumFootnote.copyWith(color: ThemeColors.black80),
        ),
        Text(
          '${restaurantDetail.name}',
          style: ThemeText.rodinaTitle3,
        ),
        SizedBox(height: 3.0),
        Text(
          '${restaurantDetail.localityVerbose} ${restaurantDetail.radius.parseRadius}',
          style:
              ThemeText.sfMediumFootnote.copyWith(color: ThemeColors.black80),
        ),
        SizedBox(height: 3.0),
        RichText(
          text: TextSpan(children: [
            TextSpan(
              text:
                  '${getFormattedCurrency(restaurantDetail?.averageCostForTwo)}',
              style: ThemeText.rodinaTitle3.copyWith(color: ThemeColors.orange),
            ),
            TextSpan(text: ' / two people', style: ThemeText.sfMediumCaption),
          ]),
        ),
      ],
    );
  }
}

extension on String {
  String get parseRadius {
    if (this == null || this.isEmpty) return '';
    return '• ${double.parse(this).toStringAsFixed(2)}km from your location';
  }
}

extension on List {
  String get joinString {
    if (this == null && this.isEmpty) return '';
    return this.take(4).map((e) => e.text).join(', ');
  }
}
