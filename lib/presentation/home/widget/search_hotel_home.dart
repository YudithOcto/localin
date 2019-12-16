import 'package:flutter/material.dart';

class SearchHotelHome extends StatefulWidget {
  @override
  _SearchHotelHomeState createState() => _SearchHotelHomeState();
}

class _SearchHotelHomeState extends State<SearchHotelHome> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 50.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                Icons.keyboard_backspace,
                color: Colors.black45,
                size: 30.0,
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
    );
  }
}
