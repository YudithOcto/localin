import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:localin/presentation/explore/detail_page/provider/explore_event_detail_provider.dart';
import 'package:localin/text_themes.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart' show rootBundle;

class ExploreDetailLocationWidget extends StatefulWidget {
  @override
  _ExploreDetailLocationWidgetState createState() =>
      _ExploreDetailLocationWidgetState();
}

class _ExploreDetailLocationWidgetState
    extends State<ExploreDetailLocationWidget> {
  String _mapStyle;
  GoogleMapController mapController;

  @override
  void initState() {
    super.initState();
    rootBundle.loadString('map_style.txt').then((string) {
      _mapStyle = string;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ExploreEventDetailProvider>(context);
    return Visibility(
      visible:
          provider.eventLocation != null && provider.eventLocation.isNotEmpty,
      child: Container(
        margin: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Location',
              style: ThemeText.sfSemiBoldHeadline,
            ),
            SizedBox(height: 8.0),
            Container(
              height: 179.0,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: GoogleMap(
                markers: provider.markers.toSet(),
                onMapCreated: (v) {
                  mapController = v;
                  mapController.setMapStyle(_mapStyle);
                },
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                      provider.locationLatitude, provider.locationLongitude),
                  zoom: 15.0,
                ),
                myLocationButtonEnabled: false,
              ),
            ),
            SizedBox(height: 12.0),
            Text(
              '${provider.eventLocation}',
              style: ThemeText.sfRegularBody,
            )
          ],
        ),
      ),
    );
  }
}
