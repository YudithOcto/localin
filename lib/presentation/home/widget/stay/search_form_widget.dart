import 'package:flutter/material.dart';
import 'package:localin/presentation/home/widget/stay/button_date_widget.dart';
import 'package:localin/provider/hotel/search_hotel_provider.dart';
import 'package:provider/provider.dart';

import '../../../../themes.dart';

class SearchFormWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<SearchHotelProvider>(
      builder: (context, searchProvider, child) {
        return Container(
          margin: EdgeInsets.only(left: 15.0, right: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Flexible(
                child: Column(
                  children: <Widget>[
                    Text(
                      'Check in',
                      style: TextStyle(
                          fontSize: 12.0, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    ButtonDateWidget(
                      isCheckInDate: true,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 5.0,
              ),
              Icon(
                Icons.arrow_forward,
                color: ThemeColors.silverGrey,
              ),
              SizedBox(
                width: 5.0,
              ),
              Flexible(
                child: Column(
                  children: <Widget>[
                    Text('Check out',
                        style: TextStyle(
                            fontSize: 12.0, fontWeight: FontWeight.w500)),
                    SizedBox(
                      height: 8.0,
                    ),
                    ButtonDateWidget(
                      isCheckInDate: false,
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 5.0, left: 10.0, right: 10.0),
                color: ThemeColors.darkGrey,
                width: 1.0,
                height: 50.0,
              ),
              Flexible(
                child: Column(
                  children: <Widget>[
                    Text('Room(s)',
                        style: TextStyle(
                            fontSize: 12.0, fontWeight: FontWeight.w500)),
                    SizedBox(
                      height: 8.0,
                    ),
                    FittedBox(
                      child: Row(
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              searchProvider.decreaseRoomTotal();
                            },
                            child: Icon(
                              Icons.remove_circle_outline,
                              color: ThemeColors.dimGrey,
                              size: 25.0,
                            ),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            '${searchProvider.userTotalPickedRoom}',
                            style: TextStyle(
                                fontSize: 14.0, color: ThemeColors.primaryBlue),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          InkWell(
                            onTap: () => searchProvider.increaseRoomTotal(),
                            child: Icon(
                              Icons.add_circle_outline,
                              size: 25.0,
                              color: ThemeColors.dimGrey,
                            ),
                          )
                        ],
                      ),
                    )
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
