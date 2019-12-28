import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localin/presentation/home/widget/home_content_default.dart';
import 'package:localin/presentation/home/widget/home_header_card.dart';
import 'package:localin/presentation/home/widget/search_hotel_widget.dart';
import 'package:localin/provider/home/home_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 5.0,
        backgroundColor: Theme.of(context).canvasColor,
        title: Image.asset(
          'images/app_bar_logo.png',
          width: MediaQuery.of(context).size.width * 0.3,
          height: 50.0,
        ),
      ),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Consumer<HomeProvider>(
          builder: (ctx, state, child) {
            return Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                HomeHeaderCard(),
                state.isRoomPage ? SearchHotelWidget() : HomeContentDefault(),
              ],
            );
          },
        ),
      ),
    );
  }

  getLocation() async {
    var result = await Provider.of<HomeProvider>(context).locationPermission();
    if (result.isNotEmpty) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text('You need to activate GPS'),
              actions: <Widget>[
                RaisedButton(
                  elevation: 5.0,
                  child: Text('Ok'),
                  onPressed: () {
                    PermissionHandler().openAppSettings();
                  },
                ),
              ],
            );
          });
    }
  }
}
