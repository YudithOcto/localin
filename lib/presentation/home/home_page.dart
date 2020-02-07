import 'package:android_intent/android_intent.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:localin/presentation/home/widget/home_content_default.dart';
import 'package:localin/presentation/home/widget/home_header_card.dart';
import 'package:localin/presentation/home/widget/search_hotel_widget.dart';
import 'package:localin/provider/home/home_provider.dart';
import 'package:localin/provider/hotel/search_hotel_provider.dart';
import 'package:provider/provider.dart';

import '../../themes.dart';

class HomePage extends StatefulWidget {
  final ValueChanged<int> valueChanged;
  HomePage({this.valueChanged});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final Geolocator location = Geolocator()..forceAndroidLocationManager;
  bool updateAndroidIntent = false;
  ScrollController controller;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      if (updateAndroidIntent) {
        checkGps();
      }
    }
  }

  checkGps() async {
    final isGpsOn = await location.isLocationServiceEnabled();

    if (!isGpsOn) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Location'),
              content: Text('You need to enable your gps'),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    final AndroidIntent intent = new AndroidIntent(
                      action: 'android.settings.LOCATION_SOURCE_SETTINGS',
                    );
                    intent.launch();
                    updateAndroidIntent = true;
                  },
                  color: Themes.primaryBlue,
                  child: Text('Enabled'),
                )
              ],
            );
          });
    } else {
      if (updateAndroidIntent) {
        Navigator.of(context).pop();
        updateAndroidIntent = false;
      }
    }
  }

  void _scrollListener() {
    if (Provider.of<HomeProvider>(context).isRoomPage &&
        controller.offset >= controller.position.maxScrollExtent) {
      Provider.of<SearchHotelProvider>(context).getHotel();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    checkGps();
    controller = new ScrollController();
    controller.addListener(_scrollListener);
  }

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
          return ListView(
            shrinkWrap: true,
            controller: controller,
            children: <Widget>[
              HomeHeaderCard(notifyParent: () {
                setState(() {});
              }),
              state.isRoomPage
                  ? SearchHotelWidget(
                      isHomePage: true,
                    )
                  : HomeContentDefault(
                      isHomePage: true,
                      onSearchBarPressed: () {
                        widget.valueChanged(4);
                      },
                    ),
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
