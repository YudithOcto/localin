import 'package:flutter/material.dart';
import 'package:localin/model/hotel/hotel_list_base_response.dart';
import 'package:localin/model/hotel/revamp_hotel_list_request.dart';
import 'package:localin/model/hotel/room_availability.dart';
import 'package:localin/model/transaction/transaction_discount_response_model.dart';
import 'package:localin/presentation/news/widgets/comments/parent_comment_card.dart';
import 'package:localin/presentation/revamp_hotel/hotel_booking_confirmation/hotel_booking_provider.dart';
import 'package:localin/themes.dart';
import 'package:localin/utils/number_helper.dart';
import 'package:provider/provider.dart';

import '../../../../text_themes.dart';

class HotelBookingPriceDetailWidget extends StatelessWidget {
  final RevampHotelListRequest request;
  final RoomAvailability roomAvailability;
  final HotelDetailEntity detail;

  HotelBookingPriceDetailWidget(
      {this.detail, this.request, this.roomAvailability});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HotelBookingProvider>(context);
    return Container(
      color: ThemeColors.black0,
      width: double.maxFinite,
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 20.0),
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                request.totalRooms,
                (index) => SinglePriceDetailRow(
                  title:
                      '(1x) ${detail.hotelName}, ${roomAvailability.categoryName}',
                  value: '${getFormattedCurrency(provider?.basePrice)}',
                ),
              )),
          Visibility(
            visible: provider.priceData != null &&
                provider.priceData.couponDiscount != null &&
                provider.priceData.couponDiscount > 0,
            child: SinglePriceDetailRow(
              title: 'Coupon',
              value:
                  '- ${getFormattedCurrency(provider.priceData?.couponDiscount)}',
            ),
          ),
          Visibility(
            visible: provider.priceData != null &&
                provider.priceData.pointDiscount != null &&
                provider.priceData.pointDiscount > 0,
            child: SinglePriceDetailRow(
              title: 'Local Point',
              value:
                  '- ${getFormattedCurrency(provider.priceData?.pointDiscount)}',
            ),
          ),
          SinglePriceDetailRow(
            title: 'Tax',
            value:
                '${provider.baseTax.isNotNullNorEmpty ? getFormattedCurrency(provider.baseTax) : 'Free'}',
          ),
          SinglePriceDetailRow(
            title: 'Service Fee',
            value:
                '${provider.baseService.isNotNullNorEmpty ? getFormattedCurrency(provider.baseService) : 'Free'}',
          ),
          SinglePriceDetailRow(
            title: 'Total',
            value: '${getFormattedCurrency(provider.totalPrice)}',
          ),
        ],
      ),
    );
  }

  String getTotal(PriceData priceData, int totalBasic) {
    if (priceData != null &&
        (priceData.pointDiscount > 0 || priceData.couponDiscount > 0)) {
      return getFormattedCurrency(priceData.userPrice);
    } else {
      return getFormattedCurrency(totalBasic);
    }
  }
}

class SinglePriceDetailRow extends StatelessWidget {
  final String title;
  final String value;

  SinglePriceDetailRow({this.title, this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Text(
                '$title',
                style: ThemeText.sfMediumHeadline,
              ),
            ),
            Text(
              '$value',
              style: ThemeText.sfMediumBody.copyWith(color: ThemeColors.orange),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: DashedLine(
            color: ThemeColors.black20,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

extension on int {
  bool get isNotNullNorEmpty {
    return this != null && this > 0;
  }
}
