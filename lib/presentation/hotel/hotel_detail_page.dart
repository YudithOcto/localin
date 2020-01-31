import 'package:flutter/material.dart';
import 'package:localin/components/base_appbar.dart';
import 'package:localin/model/hotel/hotel_list_base_response.dart';
import 'package:localin/presentation/hotel/widgets/hotel_detail_wrapper_widget.dart';
import 'package:localin/provider/hotel/hotel_detail_provider.dart';
import 'package:provider/provider.dart';

class HotelDetailPage extends StatefulWidget {
  static const routeName = '/roomDetailPage';
  static const hotelId = '/hotelId';
  static const check_in_time = '/checkinTime';
  static const check_out_time = '/checkoutTime';

  @override
  _HotelDetailPageState createState() => _HotelDetailPageState();
}

class _HotelDetailPageState extends State<HotelDetailPage> {
  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    int detail = routeArgs[HotelDetailPage.hotelId];
    DateTime checkIn = routeArgs[HotelDetailPage.check_in_time];
    DateTime checkOut = routeArgs[HotelDetailPage.check_out_time];
    return ChangeNotifierProvider<HotelDetailProvider>(
      create: (_) => HotelDetailProvider(checkIn, checkOut),
      child: Scaffold(
        appBar: BaseAppBar(
          appBar: AppBar(),
        ),
        body: ScrollContent(
          hotelId: detail,
          checkIn: checkIn,
          checkOut: checkOut,
        ),
      ),
    );
  }
}

class ScrollContent extends StatefulWidget {
  final int hotelId;
  final DateTime checkIn, checkOut;
  ScrollContent({this.hotelId, this.checkIn, this.checkOut});

  @override
  _ScrollContentState createState() => _ScrollContentState();
}

class _ScrollContentState extends State<ScrollContent> {
  Future hotelDetailFuture;

  @override
  void initState() {
    super.initState();
    hotelDetailFuture = Provider.of<HotelDetailProvider>(context, listen: false)
        .getHotelDetail(widget.hotelId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<HotelListBaseResponse>(
        future: hotelDetailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(),
                  SizedBox(height: 4.0),
                  Text('Loading Hotel Detail')
                ],
              ),
            );
          } else {
            if (snapshot.hasError || snapshot.data.error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.error_outline,
                      size: 30.0,
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text('Aw Snap. There\' an error on our side'),
                    SizedBox(
                      height: 10.0,
                    ),
                    FlatButton(
                      onPressed: () {
                        setState(() {
                          hotelDetailFuture = Provider.of<HotelDetailProvider>(
                                  context,
                                  listen: false)
                              .getHotelDetail(widget.hotelId);
                        });
                      },
                      child: Text('Retry'),
                    )
                  ],
                ),
              );
            } else {
              return HotelDetailWrapperWidget();
            }
          }
        });
  }
}
