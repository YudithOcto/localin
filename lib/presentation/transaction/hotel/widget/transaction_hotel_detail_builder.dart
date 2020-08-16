import 'package:flutter/material.dart';
import 'package:localin/presentation/transaction/hotel/provider/transaction_hotel_detail_provider.dart';
import 'package:localin/presentation/transaction/hotel/widget/transaction_hotel_booking_detail.dart';
import 'package:localin/presentation/transaction/hotel/widget/transaction_hotel_contact_detail.dart';
import 'package:localin/presentation/transaction/hotel/widget/transaction_hotel_detail_bottom_widget.dart';
import 'package:localin/presentation/transaction/hotel/widget/transaction_hotel_detail_refund_information.dart';
import 'package:localin/presentation/transaction/hotel/widget/transaction_hotel_price_detail.dart';
import 'package:localin/presentation/transaction/provider/transaction_detail_provider.dart';
import 'package:localin/themes.dart';
import 'package:localin/utils/constants.dart';
import 'package:localin/components/custom_app_bar.dart';
import 'package:localin/presentation/shared_widgets/empty_community_with_custom_message.dart';
import 'package:localin/presentation/shared_widgets/row_location_widget.dart';
import 'package:localin/presentation/shared_widgets/top_bar_transaction_status_widget.dart';
import 'package:provider/provider.dart';

import '../transaction_hotel_detail_page.dart';

class TransactionHotelDetailBuilder extends StatefulWidget {
  @override
  _TransactionHotelDetailBuilderState createState() =>
      _TransactionHotelDetailBuilderState();
}

class _TransactionHotelDetailBuilderState
    extends State<TransactionHotelDetailBuilder> {
  bool _isInit = true;

  onBackPressed() {
    if (Provider.of<TransactionHotelDetailProvider>(context).trackNeedRefresh) {
      Navigator.of(context).pop(kRefresh);
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final routes =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      final detail = routes[TransactionHotelDetailPage.bookingId];
      Provider.of<TransactionHotelDetailProvider>(context, listen: false)
          .getBookingHistoryDetail(detail);
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.black10,
      appBar: CustomAppBar(
        appBar: AppBar(),
        pageTitle: 'Purchase Details',
        leadingIcon: InkWell(
          onTap: () => onBackPressed(),
          child: Icon(
            Icons.arrow_back,
            color: ThemeColors.black80,
          ),
        ),
      ),
      bottomNavigationBar: Consumer<TransactionHotelDetailProvider>(
        builder: (_, provider, __) {
          return TransactionHotelDetailBottomWidget();
        },
      ),
      body: StreamBuilder<transactionDetailState>(
          stream: Provider.of<TransactionHotelDetailProvider>(context,
                  listen: false)
              .stream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                alignment: FractionalOffset.center,
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.2),
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.hasData &&
                  snapshot.data == transactionDetailState.success) {
                final _detail =
                    Provider.of<TransactionHotelDetailProvider>(context)
                        .bookingDetailModel;
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TopBarTransactionStatusWidget(
                        backgroundColor: ThemeColors.orange,
                        status: _detail.status,
                        expiredAt: _detail.expiredAt,
                      ),
                      TransactionHotelBookingDetail(
                        detail: _detail,
                      ),
                      TransactionHotelDetailRefundInformation(),
                      TransactionHotelContactDetail(),
                      RowLocationWidget(
                        latitude: _detail?.hotelDetail?.latitude,
                        longitude: _detail?.hotelDetail?.longitude,
                        eventName: _detail.hotelDetail.name,
                        eventAddress: _detail.hotelDetail.shortAddress,
                      ),
                      TransactionHotelPriceDetail(
                        bookingDetail: _detail,
                      ),
                    ],
                  ),
                );
              } else {
                return EmptyCommunityWithCustomMessage(
                  title: 'couldnt find your transaction',
                  message:
                      'we have trouble finding your transaction. Please try again',
                );
              }
            }
          }),
    );
  }
}
