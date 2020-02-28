import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
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
  final ScrollController controller;

  SearchHotelWidget({this.isHomePage, this.controller});

  @override
  _SearchHotelWidgetState createState() => _SearchHotelWidgetState();
}

class _SearchHotelWidgetState extends State<SearchHotelWidget> {
  bool isInit = true;
  ScrollController controller;
  Future getHotel;
  bool isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isInit) {
      final location = Provider.of<UserLocation>(context, listen: false);
      Provider.of<SearchHotelProvider>(context, listen: false)
          .setUserLocation(location);
      Provider.of<SearchHotelProvider>(context, listen: false)
          .resetAndCallApi()
          .then((value) {
        setState(() {
          isLoading = false;
        });
      });
      isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<HomeProvider>(context, listen: false);
    final searchProvider = Provider.of<SearchHotelProvider>(context);

    Future<bool> _onBackPressed(BuildContext context) {
      Provider.of<SearchHotelProvider>(context).resetParams();
      if (widget.isHomePage) {
        state.setRoomPage(false);
      } else {
        Provider.of<BookingHistoryProvider>(context).setRoomPage(false);
      }
      return null;
    }

    return WillPopScope(
      onWillPop: () => _onBackPressed(context),
      child: Column(
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
                        Future.delayed(Duration(milliseconds: 1500), () async {
                          setState(() {
                            isLoading = true;
                          });
                          FocusScope.of(context).requestFocus(FocusNode());
                          final result = await searchProvider.resetAndCallApi();
                          if (result != null) {
                            isLoading = false;
                          }
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
                      buttonDate(searchProvider.selectedCheckIn, context),
                    ],
                  ),
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
                                Future.delayed(Duration(seconds: 1), () async {
                                  searchProvider.decreaseRoomTotal();
                                  setState(() {
                                    isLoading = true;
                                  });
                                  final response =
                                      await searchProvider.resetAndCallApi();
                                  if (response != null) {
                                    isLoading = false;
                                  }
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
                ),
              ],
            ),
          ),
          isLoading
              ? Center(
                  child: Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Themes.primaryBlue),
                  ),
                ))
              : ListView.builder(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: 20.0),
                  itemCount: searchProvider.hotelDetailList.length + 1 ?? 0,
                  itemBuilder: (context, index) {
                    if (searchProvider.hotelDetailList != null &&
                        searchProvider.hotelDetailList.isNotEmpty) {
                      if (index == searchProvider.totalPage) {
                        return Container();
                      } else if (index ==
                          searchProvider.hotelDetailList.length) {
                        return Center(child: CircularProgressIndicator());
                      }
                      return HomeContentSearchHotel(
                        index: index,
                        hotel: searchProvider.hotelDetailList[index],
                        checkIn: searchProvider.selectedCheckIn,
                        checkout: searchProvider.selectedCheckOut,
                      );
                    } else {
                      return Container(
                        margin: EdgeInsets.only(top: 40.0),
                        child: Center(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              'images/no_hotel_image.jpeg',
                              width: 150.0,
                              height: 150.0,
                            ),
                            Text(
                              'Belum Ada Hotel Di Sekitarmu, Kami Akan Segera Menambahkannya Untukmu',
                              textAlign: TextAlign.center,
                            ),
                          ],
                        )),
                      );
                    }
                  },
                )
        ],
      ),
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
          setState(() {
            isLoading = true;
          });
          final response = await provider.resetAndCallApi();
          if (response != null) {
            isLoading = false;
          }
        }
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: Themes.dimGrey)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 4.0),
          child: AutoSizeText(
            '${DateHelper.formatDateRangeToString(dateTime)}',
            minFontSize: 7.0,
            maxFontSize: 14.0,
            maxLines: 1,
            style: TextStyle(
                fontWeight: FontWeight.w600, color: Themes.primaryBlue),
          ),
        ),
      ),
    );
  }
}
