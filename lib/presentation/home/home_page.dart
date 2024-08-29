import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:localin/presentation/home/widget/home_content_default.dart';
import 'package:localin/presentation/home/widget/home_header_widget.dart';
import 'package:localin/provider/auth_provider.dart';
import 'package:localin/provider/home/home_provider.dart';
import 'package:localin/provider/location/location_provider.dart';
import 'package:localin/text_themes.dart';
import 'package:provider/provider.dart';

import '../../themes.dart';

class HomePage extends StatefulWidget {
  final ValueChanged<int> valueChanged;

  HomePage({this.valueChanged});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  bool updateAndroidIntent = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      if (updateAndroidIntent) {
        checkGps(isFromDialog: true);
      }
    }
  }

  checkGps({bool isFromDialog = false}) async {
    final isPermissionPermitted =
        await Provider.of<LocationProvider>(context, listen: false)
            .checkUserPermission();
    if (isPermissionPermitted) {
      bool isGpsOn = await Geolocator.isLocationServiceEnabled();
      if (!isGpsOn) {
        showPermissionGpsDialog(false);
      } else {
        /// if user comes from background and accept all location permission/gps.
        if (updateAndroidIntent) {
          Navigator.of(context).pop();
          updateUserLocation();
          updateAndroidIntent = false;
        } else {
          updateUserLocation();
        }
      }
    } else {
      requestPermission();
    }
  }

  requestPermission() async {
    final permission = await Geolocator.requestPermission();
    switch (permission) {
      case LocationPermission.whileInUse:
      case LocationPermission.always:
        bool isGpsOn = await Geolocator.isLocationServiceEnabled();
        if (!isGpsOn) {
          showPermissionGpsDialog(false);
        } else {
          updateUserLocation();
        }
        break;
      case LocationPermission.deniedForever:
        showPermissionGpsDialog(true, isDeniedForever: true);
        break;
      case LocationPermission.denied:
        requestPermission();
        break;
      default:
        break;
    }
  }

  Future<Null> updateUserLocation({bool isRefresh = false}) async {
    final response = await Provider.of<LocationProvider>(context, listen: false)
        .updateUserLocation(isRefresh);
    if (response != null && !response.error.contains('failed')) {
      Provider.of<AuthProvider>(context, listen: false)
          .setUserModel(response.userModel);
    }
  }

  void showPermissionGpsDialog(bool isPermission,
      {bool isDeniedForever = false}) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            title: Text('${isPermission ? 'PERMISSION ACCESS' : 'GPS ACCESS'}',
                style: ThemeText.rodinaTitle3),
            content: Text(
                isPermission
                    ? 'You must enable app location permission'
                    : 'You need to always enable your GPS or location access',
                style: ThemeText.sfMediumTitle3),
            actions: <Widget>[
              RaisedButton(
                elevation: 1.0,
                color: ThemeColors.black0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                    side: BorderSide(
                      color: ThemeColors.primaryBlue,
                    )),
                onPressed: () async {
                  if (isPermission)
                    await Geolocator.openAppSettings();
                  else
                    await Geolocator.openLocationSettings();
                  updateAndroidIntent = true;

                  /// remove dialog when is denied forever. So if user changes mind to accept
                  /// location permission, we don't show this error.
                  if (isDeniedForever) {
                    Navigator.of(context).pop();
                  }
                },
                child: Text(
                  'Enabled',
                  style: ThemeText.rodinaTitle3
                      .copyWith(color: ThemeColors.primaryBlue),
                ),
              )
            ],
          );
        });
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          final provider = Provider.of<HomeProvider>(context, listen: false);
          provider.getCommunityList('');
          provider.getArticleList(isRefresh: true);
          updateUserLocation(isRefresh: true);
        },
        child: SingleChildScrollView(
          child: Consumer<HomeProvider>(
            builder: (ctx, state, child) {
              return ListView(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                children: <Widget>[
                  HomeHeaderWidget(),
                  HomeContentDefault(
                    valueChanged: widget.valueChanged,
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
