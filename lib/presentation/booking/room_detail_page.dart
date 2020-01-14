import 'package:flutter/material.dart';
import 'package:localin/components/base_appbar.dart';
import 'package:localin/presentation/booking/widgets/room_description.dart';
import 'package:localin/presentation/booking/widgets/room_general_facilities.dart';
import 'package:localin/presentation/booking/widgets/room_location.dart';
import 'package:localin/presentation/booking/widgets/room_property_policies.dart';
import 'package:localin/presentation/booking/widgets/room_recommended_by_property.dart';
import 'package:localin/presentation/booking/widgets/room_type.dart';
import 'package:localin/presentation/profile/profile_page.dart';

import '../../themes.dart';

class RoomDetailPage extends StatefulWidget {
  static const routeName = '/roomDetailPage';
  static const hotelId = '/hotelId';

  @override
  _RoomDetailPageState createState() => _RoomDetailPageState();
}

class _RoomDetailPageState extends State<RoomDetailPage> {
  final cardTextStyle = TextStyle(
      fontSize: 12.0, fontWeight: FontWeight.w600, color: Colors.black);

  @override
  Widget build(BuildContext context) {
    var platform = Theme.of(context).platform;
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: BaseAppBar(
        appBar: AppBar(),
      ),
      body: SingleChildScrollView(
        physics: platform == TargetPlatform.android
            ? ClampingScrollPhysics()
            : BouncingScrollPhysics(),
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height:
                      MediaQuery.of(context).orientation == Orientation.portrait
                          ? size.height * 0.3
                          : size.height * 0.6,
                  child: Image.asset(
                    'images/reddoor_image.jpg',
                    fit: BoxFit.fill,
                  ),
                ),
                Positioned(
                  bottom: 10.0,
                  right: 20.0,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Themes.primaryBlue.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(4.0)),
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Lihat 100 Foto',
                        style: kValueStyle.copyWith(
                            color: Colors.white, fontSize: 12.0),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 10.0,
                  left: 10.0,
                  child: Icon(
                    Icons.keyboard_backspace,
                    color: Colors.white,
                  ),
                )
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'RedDoorz Apartment near Summarecon Mall Serpong',
                    style: kValueStyle.copyWith(fontSize: 16.0),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  rowStarReview(),
                  SizedBox(
                    height: 5.0,
                  ),
                  Divider(
                    color: Colors.black54,
                  ),
                  RoomLocation(),
                  RoomDescription(),
                  RoomGeneralFacilities(),
                  RoomType(),
                  RoomPropertyPolicies(),
                  RoomRecommendedByProperty()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget rowStarReview() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(
          Icons.star,
          color: Themes.primaryBlue,
          size: 15.0,
        ),
        SizedBox(
          width: 5.0,
        ),
        Text(
          '4.0',
          style:
              cardTextStyle.copyWith(fontSize: 11.0, color: Themes.primaryBlue),
        ),
        SizedBox(
          width: 25.0,
        ),
        Text(
          '180 review',
          style: cardTextStyle.copyWith(fontSize: 11.0, color: Colors.black38),
        ),
      ],
    );
  }
}
