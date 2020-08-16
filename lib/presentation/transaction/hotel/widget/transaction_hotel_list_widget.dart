import 'package:flutter/material.dart';
import 'package:localin/model/hotel/booking_detail.dart';
import 'package:localin/model/transaction/transaction_response_model.dart';
import 'package:localin/presentation/community/community_event/provider/community_event_provider.dart';
import 'package:localin/presentation/transaction/community/widget/booking_detail_widget.dart';
import 'package:localin/presentation/transaction/hotel/transaction_hotel_detail_page.dart';
import 'package:localin/presentation/transaction/hotel/widget/transaction_hotel_empty_widget.dart';
import 'package:localin/presentation/transaction/hotel/provider/transaction_hotel_list_provider.dart';
import 'package:provider/provider.dart';

class TransactionHotelListWidget extends StatefulWidget {
  @override
  _TransactionHotelListWidgetState createState() =>
      _TransactionHotelListWidgetState();
}

class _TransactionHotelListWidgetState
    extends State<TransactionHotelListWidget> {
  bool _isInit = true;
  final _scrollController = ScrollController();

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<TransactionHotelListProvider>(context, listen: false)
          .getHotelList();
      _scrollController.addListener(() {
        if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent) {
          Provider.of<TransactionHotelListProvider>(context, listen: false)
              .getHotelList(
            isRefresh: false,
          );
        }
      });
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionHotelListProvider>(
      builder: (context, provider, child) {
        return StreamBuilder<eventState>(
          stream: provider.hotelListStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting &&
                provider.pageRequest <= 1) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView.separated(
                separatorBuilder: (context, index) => Divider(),
                shrinkWrap: true,
                controller: _scrollController,
                physics: ClampingScrollPhysics(),
                itemCount: provider.hotelList.length + 1,
                itemBuilder: (context, index) {
                  if (snapshot.data == eventState.empty) {
                    return TransactionHotelEmptyWidget();
                  } else if (index < provider.hotelList.length) {
                    return InkWell(
                      onTap: () async {
                        final result = await Navigator.of(context).pushNamed(
                            TransactionHotelDetailPage.routeName,
                            arguments: {
                              TransactionHotelDetailPage.bookingId:
                                  provider.hotelList[index]?.bookingId
                            });
                      },
                      child: BookingDetailWidget(
                        detail: getBookingDetailData(provider.hotelList[index]),
                        showPaymentRow: true,
                      ),
                    );
                  } else if (provider.canLoadMore) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return Container();
                  }
                },
              );
            }
          },
        );
      },
    );
  }

  TransactionDetailModel getBookingDetailData(BookingDetail data) {
    return TransactionDetailModel(
        transactionId: data.invoiceCode,
        modul: 'hotel',
        description: 'pesen hotel',
        transactionType: 'hotel',
        adminFee: 0,
        discount: 0,
        totalPayment: data.userPrice,
        status: data.status,
        createdAt: data.createdAt,
        expiredAt: data.createdAt,
        basicPayment: 0,
        serviceDetail: ServiceDetail(
          invoiceId: data.bookingId,
          bookingCode: data.bookingId,
          title: data.name,
          totalPayment: data.userPrice,
          startDate: data != null && data.checkIn != null
              ? DateTime.parse(data?.checkIn)
              : DateTime.now(),
          endDate: data != null && data.checkOut != null
              ? DateTime.parse(data?.checkOut)
              : DateTime.now(),
        ));
  }
}
