import 'package:flutter/material.dart';
import 'package:localin/model/service/user_location.dart';
import 'package:localin/presentation/hotel/widgets/room_detail_title.dart';
import 'package:localin/presentation/map/google_maps_full_screen.dart';
import 'package:localin/presentation/profile/profile_page.dart';
import 'package:localin/provider/hotel/hotel_detail_provider.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

class RoomLocation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final detail = Provider.of<HotelDetailProvider>(context).hotelDetailEntity;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RoomDetailTitle(
          title: 'Location',
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            InkWell(
              onTap: () {
                Navigator.of(context)
                    .pushNamed(GoogleMapFullScreen.routeName, arguments: {
                  GoogleMapFullScreen.targetLocation: UserLocation(
                      latitude: double.parse(detail?.latitude),
                      longitude: double.parse(detail?.longitude)),
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Stack(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.asset(
                        'images/static_map_image.png',
                        width: 100.0,
                        height: 100.0,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: Container(
                        alignment: FractionalOffset.center,
                        height: 25.0,
                        decoration: BoxDecoration(
                            color: Themes.primaryBlue,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(12.0),
                                bottomRight: Radius.circular(12.0))),
                        child: Text(
                          'Lihat di Peta',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 11.0),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '${detail?.street}',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                        fontSize: 12.0),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    '${detail?.shortAddress}',
                    style: kValueStyle.copyWith(
                        fontWeight: FontWeight.w500,
                        color: Themes.grey,
                        fontSize: 11.0),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Visibility(
                    visible: false,
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.location_on,
                          color: Themes.primaryBlue,
                          size: 15.0,
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          '4.6 Km near from your location',
                          style: kValueStyle.copyWith(
                              fontWeight: FontWeight.w500,
                              color: Themes.grey,
                              fontSize: 11.0),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Container(
          color: Colors.black38,
          height: 1,
          width: double.infinity,
          margin: EdgeInsets.only(top: 15.0, bottom: 5.0),
        ),
      ],
    );
  }
}
