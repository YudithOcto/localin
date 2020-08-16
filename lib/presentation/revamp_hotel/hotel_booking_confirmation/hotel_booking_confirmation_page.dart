import 'package:flutter/material.dart';
import 'package:localin/model/hotel/hotel_list_base_response.dart';
import 'package:localin/model/hotel/revamp_hotel_list_request.dart';
import 'package:localin/model/hotel/room_availability.dart';
import 'package:localin/presentation/revamp_hotel/hotel_booking_confirmation/hotel_booking_provider.dart';
import 'package:localin/presentation/revamp_hotel/hotel_booking_confirmation/widgets/hotel_booking_basic_detail_widget.dart';
import 'package:localin/presentation/revamp_hotel/hotel_booking_confirmation/widgets/hotel_booking_bottom_widget_payment.dart';
import 'package:localin/presentation/revamp_hotel/hotel_booking_confirmation/widgets/hotel_booking_contact_detail_widget.dart';
import 'package:localin/presentation/revamp_hotel/hotel_booking_confirmation/widgets/hotel_booking_price_detail_widget.dart';
import 'package:localin/presentation/shared_widgets/subtitle.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

class HotelBookingConfirmationPage extends StatelessWidget {
  static const routeName = 'HotelBookingConfirmationPage';
  static const sortRequest = 'PreviousRequest';
  static const hotelDetail = 'HotelDetail';
  static const roomDetail = 'RoomDetail';

  @override
  Widget build(BuildContext context) {
    final routes =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    HotelDetailEntity detail = routes[hotelDetail];
    RevampHotelListRequest request = routes[sortRequest];
    RoomAvailability roomRequest = routes[roomDetail];
    return ChangeNotifierProvider<HotelBookingProvider>(
      create: (_) => HotelBookingProvider(),
      child: Scaffold(
        backgroundColor: ThemeColors.black10,
        appBar: AppBar(
          backgroundColor: ThemeColors.black0,
          title:
              Text('Booking Confirmation', style: ThemeText.sfMediumHeadline),
          leading: InkResponse(
              onTap: () => Navigator.of(context).pop(),
              child: Icon(Icons.arrow_back, color: ThemeColors.black80)),
          titleSpacing: 0.0,
        ),
        bottomNavigationBar: HotelBookingBottomWidgetPayment(
          hotelDetail: detail,
          roomDetail: roomRequest,
          request: request,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 8.0),
                child: Subtitle(
                  title: 'booking detail',
                ),
              ),
              HotelBookingBasicDetailWidget(
                hotelDetail: detail,
                request: request,
                roomDetail: roomRequest,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 8.0),
                child: Subtitle(
                  title: 'Contact Details(For e-ticket)',
                ),
              ),
              HotelBookingContactDetailWidget(),
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 8.0),
                child: Subtitle(
                  title: 'Price Detail',
                ),
              ),
              HotelBookingPriceDetailWidget(
                request: request,
                roomAvailability: roomRequest,
              )
            ],
          ),
        ),
      ),
    );
  }
}
