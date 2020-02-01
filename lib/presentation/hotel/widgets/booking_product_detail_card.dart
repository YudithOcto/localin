import 'dart:async';

import 'package:flutter/material.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/hotel/booking_detail_response.dart';
import 'package:localin/presentation/hotel/widgets/location_detail_card.dart';
import 'package:localin/presentation/hotel/widgets/room_detail_card.dart';
import 'package:localin/provider/auth_provider.dart';
import 'package:localin/utils/date_helper.dart';
import 'package:provider/provider.dart';

import '../../../themes.dart';

class BookingProductDetailCard extends StatefulWidget {
  final BookingDetailModel detail;
  BookingProductDetailCard({this.detail});

  @override
  _BookingProductDetailCardState createState() =>
      _BookingProductDetailCardState();
}

class _BookingProductDetailCardState extends State<BookingProductDetailCard> {
  Timer _timer;
  String currentDifference = '';
  bool _isEnabled = true;

  void setTimer() {
    DateTime later = DateTime.parse(widget.detail.expiredAt);
    _timer = Timer.periodic(Duration(seconds: 1), (ctx) {
      DateTime now = DateTime.now();
      if (later.difference(now).inSeconds >= 0) {
        if (mounted) {
          setState(() {
            currentDifference =
                '${later.difference(now).inMinutes.toString().padLeft(2, '0')}:${(later.difference(now).inSeconds % 60).toString().padLeft(2, '0')}';
          });
        }
      } else {
        if (_timer != null && _timer.isActive) {
          _timer.cancel();
        }
        if (mounted) {
          setState(() {
            _isEnabled = false;
          });
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.detail.status == 'Saved') {
      setTimer();
    }
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
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8.0)),
      child: Column(
        children: <Widget>[
          Visibility(
              visible: widget.detail.status == 'Saved',
              child: customGreenIcon()),
          SizedBox(
            height: 10.0,
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
                  '${DateHelper.formatFromTimeStampShort(widget.detail.checkIn * 1000)}'),
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
                  '${DateHelper.formatFromTimeStampShort(widget.detail.checkOut * 1000)}'),
            ],
          ),
          customDivider(),
          RoomDetailCard(detail: widget.detail),
          customDivider(),
          LocationDetailCard(
              detail: widget.detail,
              enabled: _isEnabled,
              onPressed: () async {
                final response =
                    await Repository().cancelBooking(widget?.detail?.bookingId);
                if (response.error) {
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text('${response?.message}'),
                  ));
                } else {
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text('${response?.message}'),
                  ));
                  setState(() {
                    _isEnabled = false;
                  });
                  if (_timer != null && _timer.isActive) {
                    _timer.cancel();
                  }
                }
              }),
        ],
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

  Widget customGreenIcon() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        margin: EdgeInsets.only(top: 5.0),
        decoration: BoxDecoration(
            color: Themes.green, borderRadius: BorderRadius.circular(12.0)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Seleseikan pembayaran anda dalam',
                  style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w600)),
              Text(
                '$currentDifference',
                style: TextStyle(fontSize: 12.0, color: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget customText(String value) {
    return Text(
      value,
      style: TextStyle(
          fontSize: 14.0, fontWeight: FontWeight.w500, color: Colors.black87),
    );
  }
}
