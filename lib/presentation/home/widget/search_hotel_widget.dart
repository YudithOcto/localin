import 'dart:async';

import 'package:flutter/material.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/hotel/hotel_list_base_response.dart';
import 'package:localin/model/service/user_location.dart';
import 'package:localin/presentation/home/widget/home_content_search_hotel.dart';
import 'package:localin/provider/home/home_provider.dart';
import 'package:provider/provider.dart';

class SearchHotelWidget extends StatefulWidget {
  final Function onSearchFocused;

  SearchHotelWidget({this.onSearchFocused});

  @override
  _SearchHotelWidgetState createState() => _SearchHotelWidgetState();
}

class _SearchHotelWidgetState extends State<SearchHotelWidget> {
  Repository _repository;
  TextEditingController _searchController;
  Timer _debounce;
  Future hotelFuture;
  bool isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isInit) {
      hotelFuture = getHotel();
      isInit = false;
    }
  }

  @override
  void initState() {
    super.initState();
    _repository = Repository();
    _searchController = TextEditingController();
    _searchController.addListener(_onSearchChanged);
  }

  _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      setState(() {
        hotelFuture = getHotel();
      });
    });
  }

  Future<HotelListBaseResponse> getHotel() async {
    final location = Provider.of<UserLocation>(context);
    HotelListBaseResponse result = await _repository.getHotelList(
        '${location?.latitude}',
        '${location?.longitude}',
        '${_searchController.text}');
    return result;
  }

  @override
  void dispose() {
    _searchController.dispose();
    if (_debounce != null && _debounce.isActive) {
      _debounce.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<HomeProvider>(context, listen: false);
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 50.0, left: 10.0, right: 10.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      state.setRoomPage(false);
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
                    child: TextFormField(
                      controller: _searchController,
                      decoration: InputDecoration(
                          hintText: 'Cari hotel dekat sini',
                          hintStyle:
                              TextStyle(fontSize: 12.0, color: Colors.black38),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0))),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        FutureBuilder<HotelListBaseResponse>(
          future: hotelFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              if (snapshot.error != null) {
                return Text('${snapshot.error}');
              } else {
                return ListView.separated(
                  separatorBuilder: (context, index) {
                    return Divider();
                  },
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: 60.0),
                  itemCount: snapshot.data != null &&
                          snapshot.data.hotelDetailEntity != null
                      ? snapshot.data?.hotelDetailEntity?.length
                      : 0,
                  itemBuilder: (context, index) {
                    if (snapshot.data == null &&
                        snapshot.data.hotelDetailEntity == null) {
                      return Center(
                        child: Container(
                          child: Text('No Result'),
                        ),
                      );
                    }
                    return HomeContentSearchHotel(
                      index: index,
                      hotel: snapshot.data.hotelDetailEntity[index],
                    );
                  },
                );
              }
            }
          },
        )
      ],
    );
  }
}
