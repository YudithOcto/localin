import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localin/model/service/user_location.dart';
import 'package:localin/presentation/home/widget/home_content_default.dart';
import 'package:localin/presentation/home/widget/home_header_card.dart';
import 'package:localin/presentation/home/widget/search_hotel_widget.dart';
import 'package:localin/provider/home/home_provider.dart';
import 'package:localin/services/location_services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

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
      body: Consumer<HomeProvider>(
        builder: (ctx, state, child) {
          return CustomScrollView(
            slivers: <Widget>[
              SliverPersistentHeader(
                delegate: HomeHeaderCard(
                  notifyParent: () {
                    setState(() {});
                  },
                  expandedHeight: MediaQuery.of(context).size.height * 0.5,
                ),
                pinned: false,
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                    (_, index) => state.isRoomPage
                        ? SearchHotelWidget(
                            isHomePage: true,
                          )
                        : HomeContentDefault(
                            isHomePage: true,
                          ),
                    childCount: 1),
              )
            ],
          );
        },
      ),
    );
  }

//  getLocation() async {
//    var result = await Provider.of<HomeProvider>(context).locationPermission();
//    if (result.isNotEmpty) {
//      showDialog(
//          context: context,
//          builder: (context) {
//            return AlertDialog(
//              content: Text('You need to activate GPS'),
//              actions: <Widget>[
//                RaisedButton(
//                  elevation: 5.0,
//                  child: Text('Ok'),
//                  onPressed: () {
//                    PermissionHandler().openAppSettings();
//                  },
//                ),
//              ],
//            );
//          });
//    }
//  }
}
