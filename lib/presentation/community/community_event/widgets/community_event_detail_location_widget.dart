import 'package:flutter/material.dart';
import 'package:localin/components/custom_image_radius.dart';
import 'package:localin/components/outline_button_default.dart';
import 'package:localin/model/service/user_location.dart';
import 'package:localin/presentation/community/community_event/provider/community_event_detail_provider.dart';
import 'package:localin/presentation/map/google_maps_full_screen.dart';
import 'package:localin/presentation/shared_widgets/subtitle.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:localin/utils/location_helper.dart';
import 'package:provider/provider.dart';

class CommunityEventDetailLocationWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CommunityEventDetailProvider>(
      builder: (context, provider, child) {
        return Visibility(
          visible: provider.eventResponse.address.isNotEmpty,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                    top: 27.0, bottom: 8.0, left: 20.0, right: 20.0),
                child: Subtitle(
                  title: 'Location Detail',
                ),
              ),
              Container(
                width: double.maxFinite,
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 20.0),
                color: ThemeColors.black0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Please make your own way to: ',
                      style: ThemeText.sfMediumBody
                          .copyWith(color: ThemeColors.black80),
                    ),
                    SizedBox(
                      height: 4.0,
                    ),
                    Text(
                      '${provider.eventResponse.address}',
                      style: ThemeText.sfRegularBody,
                    ),
                    SizedBox(
                      height: 32.0,
                    ),
                    CustomImageRadius(
                      width: double.maxFinite,
                      height: 179.0,
                      imageUrl: LocationHelper.generateLocationPreviewImage(
                          double.parse(provider?.eventResponse?.latitude),
                          double.parse(provider?.eventResponse?.longitude)),
                      radius: 4.0,
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    OutlineButtonDefault(
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                            GoogleMapFullScreen.routeName,
                            arguments: {
                              GoogleMapFullScreen.targetLocation: UserLocation(
                                  latitude: double.parse(
                                      provider?.eventResponse?.latitude),
                                  longitude: double.parse(
                                      provider?.eventResponse?.longitude)),
                            });
                      },
                      buttonText: 'View in Map',
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
