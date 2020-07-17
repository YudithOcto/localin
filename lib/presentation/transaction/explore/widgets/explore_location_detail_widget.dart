import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:localin/model/service/user_location.dart';
import 'package:localin/model/transaction/transaction_explore_detail_response.dart';
import 'package:localin/presentation/map/google_maps_full_screen.dart';
import 'package:localin/presentation/news/widgets/comments/parent_comment_card.dart';
import 'package:localin/presentation/shared_widgets/subtitle.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';

class ExploreLocationDetailWidget extends StatefulWidget {
  final Data exploreDetail;
  ExploreLocationDetailWidget({@required this.exploreDetail});

  @override
  _ExploreLocationDetailWidgetState createState() =>
      _ExploreLocationDetailWidgetState();
}

class _ExploreLocationDetailWidgetState
    extends State<ExploreLocationDetailWidget> {
  List<Marker> _marker = [];
  @override
  void initState() {
    final marker = Marker(
      position: LatLng(widget.exploreDetail?.schedule?.latitude?.parseLatLong,
          widget.exploreDetail?.schedule?.longitude?.parseLatLong),
      markerId: MarkerId(widget?.exploreDetail?.event?.eventName),
    );
    _marker.add(marker);
    super.initState();
  }

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
              Text('${widget.exploreDetail?.schedule?.address}',
                  style: ThemeText.sfRegularBody),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: DashedLine(
                  color: ThemeColors.black20,
                ),
              ),
              Container(
                height: 179.0,
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: GoogleMap(
                  markers: _marker.toSet(),
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                        widget.exploreDetail?.schedule?.latitude?.parseLatLong,
                        widget
                            .exploreDetail?.schedule?.longitude?.parseLatLong),
                    zoom: 15.0,
                  ),
                  myLocationButtonEnabled: false,
                ),
              ),
              InkWell(
                onTap: () => Navigator.of(context)
                    .pushNamed(GoogleMapFullScreen.routeName, arguments: {
                  GoogleMapFullScreen.targetLocation: UserLocation(
                    latitude:
                        widget.exploreDetail?.schedule?.latitude?.parseLatLong,
                    longitude:
                        widget.exploreDetail?.schedule?.longitude?.parseLatLong,
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
