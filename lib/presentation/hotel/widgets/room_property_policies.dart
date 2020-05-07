import 'package:flutter/material.dart';
import 'package:localin/components/bullet_text.dart';
import 'package:localin/presentation/hotel/widgets/room_detail_title.dart';
import 'package:localin/provider/hotel/hotel_detail_provider.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

class RoomPropertyPolicies extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final detail = Provider.of<HotelDetailProvider>(context).hotelDetailEntity;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RoomDetailTitle(
          title: 'Property Policies',
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: detail.policies.length,
          itemBuilder: (context, index) {
            return rowRoomInformation(detail?.policies[index]);
          },
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

  Widget rowRoomInformation(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 1.0),
      child: Bullet(
        title,
        style: TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.w500,
            color: ThemeColors.dimGrey),
      ),
    );
  }
}
