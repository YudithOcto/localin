import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:localin/components/bullet_text.dart';
import 'package:localin/model/hotel/room_availability.dart';
import 'package:localin/model/hotel/room_base_response.dart';
import 'package:localin/presentation/hotel/success_booking_page.dart';
import 'package:localin/presentation/hotel/widgets/room_detail_title.dart';
import 'package:localin/provider/hotel/hotel_detail_provider.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

class RoomType extends StatefulWidget {
  @override
  _RoomTypeState createState() => _RoomTypeState();
}

class _RoomTypeState extends State<RoomType> {
  final cardTextStyle = TextStyle(
      fontSize: 14.0, fontWeight: FontWeight.w600, color: Colors.black);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HotelDetailProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RoomDetailTitle(
          title: 'Room Type',
        ),
        StreamBuilder<RoomState>(
          stream: provider.roomState,
          builder: (context, asyncSnapshot) {
            if (asyncSnapshot.data == RoomState.Busy) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (asyncSnapshot.data == RoomState.DataError) {
                return Center(
                  child: Column(
                    children: <Widget>[
                      Icon(Icons.error),
                      SizedBox(
                        height: 4.0,
                      ),
                      Text('We have connection problem, please try again'),
                    ],
                  ),
                );
              } else {
                if (provider.roomAvailability.isNotEmpty) {
                  return Column(
                    children: List.generate(provider.roomAvailability.length,
                        (index) {
                      return singleCardRoom(provider.roomAvailability[index],
                          discount: provider.discount);
                    }),
                  );
                } else {
                  return Center(
                    child: Text(
                        'Kita tidak menemukan kamar di tanggal ini. Silahkan mencari di tanggal lain'),
                  );
                }
              }
            }
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

  Widget singleCardRoom(RoomAvailability roomDetail, {int discount = 0}) {
    final provider = Provider.of<HotelDetailProvider>(context);
    return Container(
        margin: EdgeInsets.symmetric(vertical: 5.0),
        decoration: BoxDecoration(
            border: Border.all(color: Themes.grey),
            borderRadius: BorderRadius.circular(8.0)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              CachedNetworkImage(
                imageUrl: provider?.hotelDetailEntity?.images?.first,
                imageBuilder: (context, imageProvider) {
                  return Container(
                    height: 100.0,
                    width: 100.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.grey,
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        )),
                  );
                },
                placeholder: (context, index) => Container(
                  color: Colors.grey,
                  width: 100.0,
                  height: 100.0,
                ),
                placeholderFadeInDuration: Duration(milliseconds: 300),
                errorWidget: (_, url, index) => Container(
                  color: Colors.grey,
                  width: 100.0,
                  height: 100.0,
                  child: Center(
                    child: Icon(Icons.error),
                  ),
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
                        '${roomDetail.categoryName}',
                        maxLines: 2,
                        style: cardTextStyle,
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(
                            provider.hotelDetailEntity?.restrictions?.length,
                            (index) {
                          return rowRoomInformation(
                              provider.hotelDetailEntity?.restrictions[index]);
                        }),
                      ),
                      Visibility(
                        visible: false,
                        child: Expanded(
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Row(
                              children: <Widget>[
                                Text(
                                  'View Details',
                                  style: cardTextStyle.copyWith(
                                      fontSize: 11.0,
                                      color: Themes.primaryBlue),
                                ),
                                SizedBox(
                                  width: 2.0,
                                ),
                                Icon(
                                  Icons.keyboard_arrow_right,
                                  color: Themes.primaryBlue,
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                height: 100.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Visibility(
                      visible: discount != null && discount > 0,
                      child: Container(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          '${getFormattedCurrency(roomDetail?.sellingAmount)}',
                          style: cardTextStyle.copyWith(
                            decoration: TextDecoration.lineThrough,
                            fontSize: 11.0,
                            color: Colors.black38,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      '${getFormattedCurrency(roomDetail.sellingAmount - discount)}',
                      style: cardTextStyle.copyWith(
                          fontSize: 14.0, color: Themes.primaryBlue),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    RaisedButton(
                      onPressed: () async {
                        final response =
                            await provider.bookHotel(roomDetail?.categoryId);
                        if (response != null && response.error == null) {
                          Navigator.of(context).pushReplacementNamed(
                            SuccessBookingPage.routeName,
                            arguments: {
                              SuccessBookingPage.bookingData: response.detail
                            },
                          );
                        } else {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: Text('Booking Hotel'),
                                    content: Text('${response?.error}'),
                                    actions: <Widget>[
                                      FlatButton(
                                        color: Themes.primaryBlue,
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: Text(
                                          'Ok',
                                          style: TextStyle(
                                              fontSize: 12.0,
                                              color: Colors.white),
                                        ),
                                      )
                                    ],
                                  ));
                        }
                      },
                      color: Themes.primaryBlue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0)),
                      child: Text(
                        'Book Now',
                        style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }

  String getFormattedCurrency(int value) {
    if (value == null || value <= 0) return '';
    final formatter = NumberFormat('#,##0', 'en_US');
    return 'Rp ${formatter.format(value)}';
  }

  Widget rowRoomInformation(String restriction) {
    return Bullet(
      '$restriction',
      style: TextStyle(
          fontSize: 10.0, fontWeight: FontWeight.w500, color: Themes.dimGrey),
    );
  }
}
