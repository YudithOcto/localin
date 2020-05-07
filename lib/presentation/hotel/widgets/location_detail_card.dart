import 'package:flutter/material.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/hotel/booking_detail_response.dart';
import 'package:localin/model/service/user_location.dart';
import 'package:localin/presentation/map/google_maps_full_screen.dart';
import 'package:localin/presentation/webview/webview_page.dart';

import '../../../themes.dart';

class LocationDetailCard extends StatefulWidget {
  final BookingDetailModel detail;
  final bool enabled;
  final Function onPressed;
  final Function(bool) onSuccess;
  LocationDetailCard(
      {this.detail, this.enabled, this.onPressed, this.onSuccess});

  @override
  _LocationDetailCardState createState() => _LocationDetailCardState();
}

class _LocationDetailCardState extends State<LocationDetailCard> {
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
                          latitude: double.parse(
                              widget.detail?.hotelDetail?.latitude),
                          longitude: double.parse(
                              widget.detail?.hotelDetail?.longitude),
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
                '${widget.detail?.street}',
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
              visible: !(widget.detail?.status == 'Cancelled Booking'),
              child: customButtonWithBorder(
                  'Batalkan Pesanan', Icons.cancel, context, Colors.white,
                  onPressed: widget.onPressed),
            )),
            SizedBox(
              width: 10.0,
            ),
            Expanded(
                child: Visibility(
              visible: widget.detail?.status == 'Saved',
              child: customButtonWithBorder('Bayar', Icons.payment, context,
                  !widget.enabled ? Colors.grey : Colors.blue,
                  onPressed: () async {
                if (widget.enabled) {
                  final response = await Repository()
                      .bookingPayment(widget.detail?.bookingId);
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
                      widget.onSuccess(true);
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text('$result'),
                      ));
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
      String title, IconData icon, BuildContext context, Color color,
      {@required Function onPressed}) {
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
          Text(
            title,
            style: TextStyle(
                fontSize: 12.0,
                color:
                    title == 'Bayar' ? Colors.white : ThemeColors.primaryBlue,
                fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }
}
