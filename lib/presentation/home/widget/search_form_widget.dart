import 'package:flutter/material.dart';
import 'package:localin/provider/home/home_provider.dart';
import 'package:provider/provider.dart';

class SearchFormWidget extends StatefulWidget {
  @override
  _SearchFormWidgetState createState() => _SearchFormWidgetState();
}

class _SearchFormWidgetState extends State<SearchFormWidget> {
  @override
  Widget build(BuildContext context) {
    var state = Provider.of<HomeProvider>(context, listen: false);
    return Container(
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
    );
  }
}
