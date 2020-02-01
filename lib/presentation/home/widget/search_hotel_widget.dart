import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:localin/model/hotel/hotel_list_base_response.dart';
import 'package:localin/provider/hotel/search_hotel_provider.dart';
import 'package:localin/themes.dart';
import 'package:localin/utils/custom_date_range_picker.dart' as dtf;

import 'package:flutter/material.dart';
import 'package:localin/model/service/user_location.dart';
import 'package:localin/presentation/home/widget/home_content_search_hotel.dart';
import 'package:localin/provider/home/home_provider.dart';
import 'package:localin/provider/hotel/booking_history_provider.dart';
import 'package:localin/utils/date_helper.dart';
import 'package:provider/provider.dart';

class SearchHotelWidget extends StatefulWidget {
  final bool isHomePage;

  SearchHotelWidget({this.isHomePage});

  @override
  _SearchHotelWidgetState createState() => _SearchHotelWidgetState();
}

class _SearchHotelWidgetState extends State<SearchHotelWidget> {
  bool isInit = true;
  PagewiseLoadController _pageLoadController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isInit) {
      final location = Provider.of<UserLocation>(context);
      Provider.of<SearchHotelProvider>(context).setUserLocation(location);
      _pageLoadController = PagewiseLoadController<HotelDetailEntity>(
          pageSize: 6,
          pageFuture: (pageIndex) => Provider.of<SearchHotelProvider>(context)
              .getHotel(pageIndex * 6, 6));
      isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<HomeProvider>(context, listen: false);
    final searchProvider = Provider.of<SearchHotelProvider>(context);
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 50.0, left: 10.0, right: 10.0),
          child: Row(
            children: <Widget>[
              InkWell(
                onTap: () {
                  if (widget.isHomePage) {
                    state.setRoomPage(false);
                  } else {
                    Provider.of<BookingHistoryProvider>(context)
                        .setRoomPage(false);
                  }
                },
                child: Icon(
                  Icons.keyboard_backspace,
                  color: Colors.black45,
                  size: 30.0,
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: Container(
                  height: 40.0,
                  child: TextFormField(
                    controller: searchProvider.searchController,
                    onChanged: (value) async {
                      Future.delayed(Duration(milliseconds: 1500), () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        _pageLoadController.reset();
                      });
                    },
                    decoration: InputDecoration(
                        hintText: 'Cari hotel dekat sini',
                        contentPadding: EdgeInsets.all(5.0),
                        hintStyle:
                            TextStyle(fontSize: 12.0, color: Colors.black38),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0))),
                  ),
                ),
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 15.0, right: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    'Check in',
                    style:
                        TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  buttonDate(searchProvider.selectedCheckIn, context),
                ],
              ),
              SizedBox(
                width: 5.0,
              ),
              Icon(
                Icons.arrow_forward,
                color: Themes.silverGrey,
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
                    buttonDate(searchProvider.selectedCheckOut, context),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 5.0, left: 10.0, right: 10.0),
                color: Themes.darkGrey,
                width: 1.0,
                height: 50.0,
              ),
              Column(
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
                            Future.delayed(Duration(seconds: 1), () {
                              searchProvider.decreaseRoomTotal();
                              _pageLoadController.reset();
                            });
                          },
                          child: Icon(
                            Icons.remove_circle_outline,
                            color: Themes.dimGrey,
                            size: 25.0,
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text(
                          '${searchProvider.userTotalPickedRoom}',
                          style: TextStyle(
                              fontSize: 14.0, color: Themes.primaryBlue),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        InkWell(
                          onTap: () => searchProvider.increaseRoomTotal(),
                          child: Icon(
                            Icons.add_circle_outline,
                            size: 25.0,
                            color: Themes.dimGrey,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        PagewiseListView(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, item, index) {
            return HomeContentSearchHotel(
              index: index,
              hotel: item,
              checkIn: searchProvider.selectedCheckIn,
              checkout: searchProvider.selectedCheckOut,
            );
          },
          pageLoadController: _pageLoadController,
        )
      ],
    );
  }

  Widget buttonDate(DateTime dateTime, BuildContext context) {
    final provider = Provider.of<SearchHotelProvider>(context);
    return InkWell(
      onTap: () async {
        final List<DateTime> pick = await dtf.showDatePicker(
            context: context,
            initialFirstDate: provider.selectedCheckIn,
            initialLastDate: provider.selectedCheckOut,
            firstDate: new DateTime(
                DateTime.now().year, DateTime.now().month, DateTime.now().day),
            lastDate: new DateTime(2025));
        if (pick != null && pick.length == 2) {
          provider.setSelectedDate(pick[0], pick[1]);
          _pageLoadController.reset();
        }
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: Themes.dimGrey)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 4.0),
          child: Text(
            '${DateHelper.formatDateRangeToString(dateTime)}',
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12.0,
                color: Themes.primaryBlue),
          ),
        ),
      ),
    );
  }
}
