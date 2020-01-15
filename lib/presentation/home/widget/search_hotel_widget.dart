import 'package:flutter/material.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/hotel/hotel_list_base_response.dart';
import 'package:localin/presentation/home/widget/home_content_search_hotel.dart';
import 'package:localin/provider/home/home_provider.dart';
import 'package:provider/provider.dart';

class SearchHotelWidget extends StatefulWidget {
  @override
  _SearchHotelWidgetState createState() => _SearchHotelWidgetState();
}

class _SearchHotelWidgetState extends State<SearchHotelWidget> {
  Repository _repository;

  @override
  void initState() {
    super.initState();
    _repository = Repository();
  }

  Future<HotelListBaseResponse> getHotel() async {
    HotelListBaseResponse result = await _repository.getHotelList(
        '-6.2101332821540405', '106.85041666923462', 'oyo');
    return result;
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
          future: getHotel(),
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
                  itemCount: snapshot.data?.hotelList?.length,
                  itemBuilder: (context, index) {
                    return HomeContentSearchHotel(
                      index: index,
                      hotel: snapshot.data.hotelList[index],
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
