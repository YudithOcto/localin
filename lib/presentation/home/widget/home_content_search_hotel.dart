import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:localin/model/hotel/hotel_list_base_response.dart';
import 'package:localin/presentation/hotel/hotel_detail_page.dart';

import '../../../themes.dart';

class HomeContentSearchHotel extends StatelessWidget {
  final cardTextStyle = TextStyle(
      fontSize: 12.0, fontWeight: FontWeight.w600, color: Colors.black);

  final int index;
  final HotelDetailEntity hotel;
  final DateTime checkIn, checkout;
  HomeContentSearchHotel({this.index, this.hotel, this.checkIn, this.checkout});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: hotel != null &&
          hotel.roomAvailability != null &&
          hotel.roomAvailability.isNotEmpty,
      child: InkWell(
        onTap: () {
          Navigator.of(context)
              .pushNamed(HotelDetailPage.routeName, arguments: {
            HotelDetailPage.hotelId: hotel.hotelId,
            HotelDetailPage.check_in_time: checkIn,
            HotelDetailPage.check_out_time: checkout,
          });
        },
        child: Container(
          margin: EdgeInsets.only(
              top: index == 0 ? 10.0 : 0.0, left: 15.0, right: 15.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 15.0,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CachedNetworkImage(
                    imageUrl: hotel?.image ?? '',
                    imageBuilder: (context, imageProvider) {
                      return Container(
                        width: 50.0,
                        height: 50.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.cover)),
                      );
                    },
                    placeholder: (context, url) => Container(
                      width: 50.0,
                      height: 50.0,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
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
                              fontWeight: FontWeight.w500,
                              color: Colors.black38,
                              fontSize: 11.0),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.location_on,
                              color: ThemeColors.primaryBlue,
                              size: 15.0,
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              '${hotel.distance}',
                              style: cardTextStyle.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                  fontSize: 11.0),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          '${hotel.roomAvailability != null && hotel.roomAvailability.isNotEmpty ? getFormattedCurrency(hotel?.roomAvailability?.first?.sellingAmount) : ''}',
                          style: cardTextStyle.copyWith(
                            decoration: TextDecoration.lineThrough,
                            fontWeight: FontWeight.w500,
                            fontSize: 11.0,
                            color: Colors.black38,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        '${hotel.roomAvailability != null && hotel.roomAvailability.isNotEmpty ? getFormattedCurrency(hotel.roomAvailability.first.sellingAmount - (hotel.discount ?? 0)) : ''}',
                        style: cardTextStyle.copyWith(
                            fontSize: 14.0, color: ThemeColors.primaryBlue),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Visibility(
                        visible: hotel.roomAvailability != null &&
                            hotel.roomAvailability.isNotEmpty,
                        child: Text(
                          '/Room/Night',
                          style: cardTextStyle.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 11.0,
                              color: Colors.black38),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 15.0,
              )
            ],
          ),
        ),
      ),
    );
  }

  String getFormattedCurrency(int value) {
    if (value == null || value <= 0) return '';
    final formatter = NumberFormat('#,##0', 'en_US');
    return 'Rp ${formatter.format(value)}';
  }
}
