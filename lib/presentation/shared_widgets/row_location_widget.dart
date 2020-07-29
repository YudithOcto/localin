import 'package:flutter/material.dart';
import 'package:localin/components/custom_image_radius.dart';
import 'package:localin/model/service/user_location.dart';
import 'package:localin/presentation/map/google_maps_full_screen.dart';
import 'package:localin/presentation/news/widgets/comments/parent_comment_card.dart';
import 'package:localin/presentation/shared_widgets/subtitle.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:localin/utils/location_helper.dart';

class RowLocationWidget extends StatelessWidget {
  final String latitude;
  final String longitude;
  final String eventName;
  final String eventAddress;
  RowLocationWidget(
      {this.latitude, this.longitude, this.eventName, this.eventAddress});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
              top: 24.0, bottom: 8.0, left: 20.0, right: 20.0),
          child: Subtitle(
            title: 'LOCATION DETAIL',
          ),
        ),
        Container(
          width: double.maxFinite,
          color: ThemeColors.black0,
          margin: EdgeInsets.only(top: 4.0),
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Please make your own way to: ',
                  style: ThemeText.sfMediumBody
                      .copyWith(color: ThemeColors.black80)),
              SizedBox(height: 4.0),
              Text('$eventAddress', style: ThemeText.sfRegularBody),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: DashedLine(
                  color: ThemeColors.black20,
                ),
              ),
              CustomImageRadius(
                height: 179.0,
                width: double.infinity,
                radius: 8.0,
                imageUrl: LocationHelper.generateLocationPreviewImage(
                    latitude.parseLatLong, longitude.parseLatLong),
              ),
              SizedBox(height: 10.0),
              InkWell(
                onTap: () => Navigator.of(context)
                    .pushNamed(GoogleMapFullScreen.routeName, arguments: {
                  GoogleMapFullScreen.targetLocation: UserLocation(
                    latitude: latitude.parseLatLong,
                    longitude: longitude.parseLatLong,
                  )
                }),
                child: Container(
                  height: 48.0,
                  width: double.maxFinite,
                  alignment: FractionalOffset.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0),
                    border: Border.all(color: ThemeColors.primaryBlue),
                  ),
                  child: Text(
                    'View in Map',
                    style: ThemeText.rodinaTitle3
                        .copyWith(color: ThemeColors.primaryBlue),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

extension on String {
  double get parseLatLong {
    if (this == null || this.isEmpty) return 0.0;
    return double.parse(this);
  }
}
