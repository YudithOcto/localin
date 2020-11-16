import 'package:flutter/material.dart';
import 'package:localin/presentation/transaction/hotel/provider/transaction_hotel_detail_provider.dart';
import 'package:localin/presentation/transaction/hotel/widget/transaction_hotel_detail_builder.dart';
import 'package:localin/presentation/transaction/provider/transaction_detail_provider.dart';
import 'package:provider/provider.dart';

class TransactionHotelDetailPage extends StatelessWidget {
  static const routeName = 'TransactionHotelDetailPage';
  static const bookingId = 'TransactionBookingId';
  static const fromSuccessPage = 'FromSuccessPage';

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<TransactionHotelDetailProvider>(
          create: (_) => TransactionHotelDetailProvider(),
        ),
        ChangeNotifierProvider<TransactionDetailProvider>(
          create: (_) => TransactionDetailProvider(),
        )
      ],
      child: TransactionHotelDetailBuilder(),
    );
  }
}
