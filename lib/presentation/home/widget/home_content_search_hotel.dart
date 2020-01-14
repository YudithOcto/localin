import 'package:flutter/material.dart';
import 'package:localin/model/hotel/hotel_list_base_response.dart';
import 'package:localin/presentation/booking/room_detail_page.dart';

import '../../../themes.dart';

class HomeContentSearchHotel extends StatelessWidget {
  final cardTextStyle = TextStyle(
      fontSize: 12.0, fontWeight: FontWeight.w600, color: Colors.black);

  final int index;
  final HotelListEntity hotel;
  HomeContentSearchHotel({this.index, this.hotel});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(RoomDetailPage.routeName,
            arguments: {RoomDetailPage.hotelId: hotel.hotelId});
      },
      child: Container(
        margin: EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 15.0,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.asset(
                    'images/cafe.jpg',
                    fit: BoxFit.fill,
                    width: 100.0,
                    height: 100.0,
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: Container(
                    height: 100.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '${hotel.hotelName}',
                          style: cardTextStyle,
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          '${hotel.shortAddress}',
                          style: cardTextStyle.copyWith(
                              color: Colors.black38, fontSize: 11.0),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Row(
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
                              '${hotel.distance}',
                              style: cardTextStyle.copyWith(
                                  color: Colors.black38, fontSize: 11.0),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
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
                                  style: cardTextStyle.copyWith(
                                      fontSize: 11.0,
                                      color: Themes.primaryBlue),
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Text(
                                  '180 review',
                                  style: cardTextStyle.copyWith(
                                      fontSize: 11.0, color: Colors.black38),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 80.0,
                  height: 100.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          'Rp 275.000',
                          style: cardTextStyle.copyWith(
                            decoration: TextDecoration.lineThrough,
                            fontSize: 11.0,
                            color: Colors.black38,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        'Rp ${hotel.roomAvailability != null && hotel.roomAvailability.isNotEmpty ? hotel.roomAvailability.first.sellingAmount : ''}',
                        style: cardTextStyle.copyWith(
                            fontSize: 14.0, color: Themes.primaryBlue),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        '/Room/Night',
                        style: cardTextStyle.copyWith(
                            fontSize: 11.0, color: Colors.black38),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
