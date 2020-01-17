import 'package:flutter/material.dart';
import 'package:localin/components/bullet_text.dart';
import 'package:localin/components/rounded_button_fill.dart';
import 'package:localin/presentation/hotel/widgets/room_detail_title.dart';
import 'package:localin/provider/hotel/hotel_detail_provider.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

class RoomType extends StatelessWidget {
  final cardTextStyle = TextStyle(
      fontSize: 12.0, fontWeight: FontWeight.w600, color: Colors.black);
  @override
  Widget build(BuildContext context) {
    final detail = Provider.of<HotelDetailProvider>(context).hotelDetailEntity;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RoomDetailTitle(
          title: 'Room Type',
        ),
        Column(
          children: List.generate(3, (index) {
            return singleCardRoom();
          }),
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

  Widget singleCardRoom() {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 5.0),
        decoration: BoxDecoration(
            border: Border.all(color: Themes.grey),
            borderRadius: BorderRadius.circular(8.0)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
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
                        'RedDoorz Apartment near Summarecon Mall Serpong',
                        maxLines: 2,
                        style: cardTextStyle,
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Column(
                        children: List.generate(3, (index) {
                          return rowRoomInformation();
                        }),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Row(
                            children: <Widget>[
                              Text(
                                'View Details',
                                style: cardTextStyle.copyWith(
                                    fontSize: 11.0, color: Themes.primaryBlue),
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
                      'Rp 233.750',
                      style: cardTextStyle.copyWith(
                          fontSize: 14.0, color: Themes.primaryBlue),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    RoundedButtonFill(
                      onPressed: () {},
                      title: 'Book Now',
                      titleColor: Colors.white,
                      backgroundColor: Themes.primaryBlue,
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }

  Widget rowRoomInformation() {
    return Bullet(
      'Pay Now Only',
      style: TextStyle(
          fontSize: 10.0, fontWeight: FontWeight.w500, color: Themes.dimGrey),
    );
  }
}
