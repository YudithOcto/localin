import 'package:android_intent/android_intent.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:localin/presentation/home/widget/home_content_default.dart';
import 'package:localin/presentation/home/widget/home_header_widget.dart';
import 'package:localin/presentation/home/widget/search_hotel_widget.dart';
import 'package:localin/provider/home/home_provider.dart';
import 'package:localin/provider/hotel/search_hotel_provider.dart';
import 'package:localin/provider/location/location_provider.dart';
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
        checkGps(fromDialog: true);
      }
    }
  }

  checkGps({bool fromDialog = false}) async {
    bool isGpsOn = true;
    if (isGpsOn) {
      isGpsOn = await location.isLocationServiceEnabled();
    } else {
      isGpsOn = await Provider.of<LocationProvider>(context, listen: false)
          .getUserLocation();
    }
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
                  color: ThemeColors.primaryBlue,
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
//    if (Provider.of<HomeProvider>(context).isRoomPage) {
//      final searchProvider =
//          Provider.of<SearchHotelProvider>(context, listen: false);
//      if (searchProvider.hotelDetailList != null &&
//          searchProvider.hotelDetailList.isNotEmpty &&
//          controller.offset >= controller.position.maxScrollExtent &&
//          !searchProvider.isLoading &&
//          searchProvider.totalPage > searchProvider.hotelDetailList.length) {
//        searchProvider.setLoading();
//        searchProvider.getHotel();
//      }
//    } else {
//      final homeProvider = Provider.of<HomeProvider>(context, listen: false);
//      if (homeProvider.articleDetail != null &&
//          homeProvider.articleDetail.isNotEmpty &&
//          controller.offset >= controller.position.maxScrollExtent &&
//          !homeProvider.isLoading &&
//          homeProvider.articleDetail != null &&
//          homeProvider.total > homeProvider.articleDetail.length) {
//        // Provider.of<HomeProvider>(context, listen: false).getArticleList();
//      }
//    }
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
      body: SingleChildScrollView(
        child: Consumer<HomeProvider>(
          builder: (ctx, state, child) {
            return ListView(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              children: <Widget>[
//              HomeHeaderCard(notifyParent: () {
//                setState(() {});
//              }),
                HomeHeaderWidget(),
                HomeContentDefault(),
//                state.isRoomPage
//                    ? SearchHotelWidget(
//                        isHomePage: true,
//                      )
//                    : HomeContentDefault(
//                        isHomePage: true,
//                        onSearchBarPressed: () {
//                          widget.valueChanged(4);
//                        },
//                      ),
              ],
            );
          },
        ),
      ),
    );
  }
}
