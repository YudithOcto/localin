import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/hotel/book_hotel_response.dart';
import 'package:localin/model/service/user_location.dart';
import 'package:localin/presentation/map/google_maps_full_screen.dart';
import 'package:localin/presentation/webview/webview_page.dart';
import 'package:localin/provider/auth_provider.dart';
import 'package:localin/utils/date_helper.dart';
import 'package:provider/provider.dart';

import '../../themes.dart';

class SuccessBookingPage extends StatefulWidget {
  static const routeName = '/successBookingPage';
  static const bookingData = 'bookingData';
  @override
  _SuccessBookingPageState createState() => _SuccessBookingPageState();
}

class _SuccessBookingPageState extends State<SuccessBookingPage> {
  BookHotelDetailResponse detail = BookHotelDetailResponse();
  bool isInit = true;
  Timer _timer;
  String currentDifference = '';
  bool _isEnabled = true;
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  bool isNeedRefresh = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isInit) {
      final routeArgs =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      detail = routeArgs[SuccessBookingPage.bookingData];
      if (detail.status == 'Saved') {
        setTimer();
      }
      isInit = false;
    }
  }

  void setTimer() {
    DateTime later = DateTime.parse(detail.expiredAt);
    _timer = Timer.periodic(Duration(seconds: 1), (ctx) {
      DateTime now = DateTime.now();
      if (later.difference(now).inSeconds >= 0) {
        setState(() {
          currentDifference =
              '${later.difference(now).inMinutes.toString().padLeft(2, '0')}:${(later.difference(now).inSeconds % 60).toString().padLeft(2, '0')}';
        });
      } else {
        if (_timer != null && _timer.isActive) {
          _timer.cancel();
        }
        setState(() {
          _isEnabled = false;
        });
      }
    });
  }

  @override
  void dispose() {
    if (_timer != null && _timer.isActive) {
      _timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      backgroundColor: ThemeColors.darkBlue,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 5.0,
        backgroundColor: Theme.of(context).canvasColor,
        title: Image.asset(
          'images/app_bar_logo.png',
          width: MediaQuery.of(context).size.width * 0.3,
          height: 30.0,
        ),
      ),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: Icon(
                    Icons.keyboard_backspace,
                    color: Colors.white,
                    size: 40.0,
                  ),
                ),
              ),
              Center(
                child: Image.asset(
                  'images/success_icon.png',
                  scale: 2.0,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Center(
                child: Text(
                  '${detail?.status}',
                  style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              Center(
                child: Text(
                  'Booking ID: ${detail?.invoiceCode}',
                  style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w300),
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Container(
                padding: EdgeInsets.all(8.0),
                color: Colors.white,
                child: ListView(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  children: <Widget>[
                    Visibility(
                        visible: detail?.status == 'Saved',
                        child: customRoundedButton()),
                    SizedBox(
                      height: 5.0,
                    ),
                    customText(
                        '${Provider.of<AuthProvider>(context).userModel.username}'),
                    SizedBox(
                      height: 5.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        customText(
                            '${DateHelper.formatDateBookingDetailShort(detail.requestCheckInDate)}'),
                        SizedBox(
                          width: 15.0,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(2.0)),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              '1N',
                              style: TextStyle(fontSize: 10.0),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 15.0,
                        ),
                        customText(
                            '${DateHelper.formatDateBookingDetailShort(detail.requestCheckOutDate)}'),
                      ],
                    ),
                    customDivider(),
                    SuccessRoomDetail(detail: detail),
                    customDivider(),
                    Builder(
                      builder: (ctx) {
                        return LocationDetail(
                          detail: detail,
                          isEnabled: _isEnabled,
                          onSuccess: (isSuccess) {
                            if (isSuccess) {
                              setState(() {
                                detail.status = 'Confirm Booking';
                              });
                            }
                          },
                          onPressed: () async {
                            final response = await Repository()
                                .cancelBooking(detail?.bookingId);
                            if (response.error) {
                              key.currentState.showSnackBar(SnackBar(
                                content: Text('${response?.message}'),
                              ));
                            } else {
                              key.currentState.showSnackBar(SnackBar(
                                content: Text('${response?.message}'),
                              ));
                              if (_timer != null && _timer.isActive) {
                                _timer.cancel();
                              }
                              setState(() {
                                isNeedRefresh = true;
                                _isEnabled = false;
                                detail.status = 'Cancelled Booking';
                              });
                            }
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget customDivider() {
    return Container(
      color: Colors.black26,
      width: double.infinity,
      height: 1.0,
      margin: EdgeInsets.symmetric(vertical: 10.0),
    );
  }

  Widget customText(String value) {
    return Text(
      value,
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: 14.0, fontWeight: FontWeight.w500, color: Colors.black87),
    );
  }

  Widget customRoundedButton() {
    return Container(
      margin: EdgeInsets.only(top: 15.0, bottom: 5.0),
      decoration: BoxDecoration(
          color: ThemeColors.green, borderRadius: BorderRadius.circular(8.0)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('Selesaikan pembayaran anda dalam',
                style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w500)),
            Text(
              '$currentDifference',
              style: TextStyle(
                  fontSize: 11.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }
}

class SuccessRoomDetail extends StatelessWidget {
  final BookHotelDetailResponse detail;
  SuccessRoomDetail({this.detail});
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '${detail?.hotelDetail?.name}',
                  style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  '${detail?.hotelDetail?.state}',
                  style: TextStyle(
                      fontSize: 11.0,
                      color: Colors.black38,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Flexible(
                        child: blueCard('Guests', '${detail?.adultCount}')),
                    Flexible(child: blueCard('Rooms', '${detail?.roomName}')),
                    Flexible(
                      child: blueCard('Price',
                          '${getFormattedCurrency(detail?.userPrice)}'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CachedNetworkImage(
            imageUrl: '${detail?.hotelImage}',
            imageBuilder: (context, imageProvider) {
              return Container(
                width: 100.0,
                height: 100.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover)),
              );
            },
            errorWidget: (ctx, item, child) => Container(
              height: 100.0,
              width: 100.0,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String getFormattedCurrency(int value) {
    if (value == null) return '';
    if (value == 0) return 'IDR 0';
    final formatter = NumberFormat('#,##0', 'en_US');
    return 'IDR ${formatter.format(value)}';
  }

  Widget blueCard(String title, String value) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(left: 5.0, right: 5.0),
      decoration: BoxDecoration(
          color: ThemeColors.primaryBlue,
          borderRadius: BorderRadius.circular(4.0)),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 11.0, color: Colors.white),
            ),
            SizedBox(
              height: 5.0,
            ),
            Text(value,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 11.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }
}

class LocationDetail extends StatelessWidget {
  final BookHotelDetailResponse detail;
  final bool isEnabled;
  final Function onPressed;
  final Function(bool) onSuccess;
  LocationDetail(
      {this.detail, this.isEnabled, @required this.onPressed, this.onSuccess});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Stack(
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed(GoogleMapFullScreen.routeName, arguments: {
                        GoogleMapFullScreen.targetLocation: UserLocation(
                          latitude: double.parse(detail?.hotelDetail?.latitude),
                          longitude:
                              double.parse(detail?.hotelDetail?.longitude),
                        )
                      });
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.asset(
                        'images/static_map_image.png',
                        width: 100.0,
                        height: 100.0,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: Container(
                      alignment: FractionalOffset.center,
                      height: 25.0,
                      decoration: BoxDecoration(
                          color: ThemeColors.primaryBlue,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(12.0),
                              bottomRight: Radius.circular(12.0))),
                      child: Text(
                        'Lihat di Peta',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 11.0),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Text(
                '${detail?.hotelDetail?.street}',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                    fontSize: 12.0),
              ),
            )
          ],
        ),
        SizedBox(
          height: 20.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(
              width: 20.0,
            ),
            Expanded(
                child: Visibility(
              visible: !(detail.status == 'Cancelled Booking'),
              child: customButtonWithBorder(
                  isEnabled, 'Batalkan Pesanan', Icons.cancel, Colors.white,
                  onPressed: onPressed),
            )),
            SizedBox(
              width: 10.0,
            ),
            Expanded(
                child: Visibility(
              visible: detail?.status == 'Saved' && isEnabled,
              child: customButtonWithBorder(isEnabled, 'Bayar', Icons.payment,
                  !isEnabled ? Colors.grey : Colors.blue, onPressed: () async {
                if (isEnabled) {
                  final response =
                      await Repository().bookingPayment(detail?.bookingId);
                  if (response.error) {
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text('${response.message}'),
                    ));
                  } else {
                    final result = await Navigator.of(context)
                        .pushNamed(WebViewPage.routeName, arguments: {
                      WebViewPage.urlName: response?.urlRedirect,
                      WebViewPage.title: 'Dana',
                    });
                    if (result != null) {
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text('$result'),
                      ));
                      onSuccess(true);
                    }
                  }
                } else {
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text(
                        'masa pembayaran sudah terlewati. Silahkan pesan lagi'),
                  ));
                }
              }),
            )),
            SizedBox(
              width: 20.0,
            ),
          ],
        ),
        SizedBox(
          height: 15.0,
        ),
      ],
    );
  }

  Widget customButtonWithBorder(
      bool isEnabled, String title, IconData icon, Color color,
      {Function onPressed}) {
    return RaisedButton(
      color: color,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: BorderSide(
              color: title == 'Bayar' ? Colors.white : ThemeColors.primaryBlue,
              width: 2.0)),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            icon,
            color: title == 'Bayar' ? Colors.white : ThemeColors.primaryBlue,
            size: 15.0,
          ),
          SizedBox(
            width: 10.0,
          ),
          Flexible(
            child: Text(
              title,
              style: TextStyle(
                  fontSize: 12.0,
                  color:
                      title == 'Bayar' ? Colors.white : ThemeColors.primaryBlue,
                  fontWeight: FontWeight.w600),
            ),
          )
        ],
      ),
    );
  }
}
