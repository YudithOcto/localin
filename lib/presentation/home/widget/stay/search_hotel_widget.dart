import 'package:flutter/cupertino.dart';
import 'package:localin/presentation/home/widget/home_content_search_hotel.dart';
import 'package:localin/presentation/home/widget/stay/empty_hotel_widget.dart';
import 'package:localin/presentation/home/widget/stay/search_form_widget.dart';
import 'package:localin/provider/hotel/search_hotel_provider.dart';
import 'package:flutter/material.dart';
import 'package:localin/provider/home/home_provider.dart';
import 'package:localin/provider/hotel/booking_history_provider.dart';
import 'package:localin/provider/location/location_provider.dart';
import 'package:provider/provider.dart';

class SearchHotelWidget extends StatefulWidget {
  final bool isHomePage;

  SearchHotelWidget({this.isHomePage});

  @override
  _SearchHotelWidgetState createState() => _SearchHotelWidgetState();
}

class _SearchHotelWidgetState extends State<SearchHotelWidget> {
  bool isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isInit) {
      final searchHotelProvider =
          Provider.of<SearchHotelProvider>(context, listen: false);
      searchHotelProvider.setUserLocation(
          Provider.of<LocationProvider>(context, listen: false)
              .userCoordinates);
      searchHotelProvider.getHotel(isRefresh: true);
      isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<HomeProvider>(context, listen: false);
    final searchProvider = Provider.of<SearchHotelProvider>(context);

    Future<bool> _onBackPressed(BuildContext context) {
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
          SearchFormWidget(),
          SizedBox(
            height: 15.0,
          ),
          StreamBuilder<SearchViewState>(
              stream: searchProvider.searchStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting &&
                    !snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: 20.0),
                  itemCount: searchProvider.hotelDetailList.length + 1 ?? 0,
                  itemBuilder: (context, index) {
                    if (index < searchProvider.hotelDetailList.length) {
                      return HomeContentSearchHotel(
                        index: index,
                        hotel: searchProvider.hotelDetailList[index],
                        checkIn: searchProvider.selectedCheckIn,
                        checkout: searchProvider.selectedCheckOut,
                      );
                    } else if (searchProvider.canLoadMore) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return EmptyHotelWidget();
                    }
                  },
                );
              })
        ],
      ),
    );
  }
}
