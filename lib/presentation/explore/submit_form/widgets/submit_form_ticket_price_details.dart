import 'package:flutter/material.dart';
import 'package:localin/presentation/explore/submit_form/providers/submit_form_provider.dart';
import 'package:localin/presentation/news/widgets/comments/parent_comment_card.dart';
import 'package:localin/presentation/shared_widgets/subtitle.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:localin/utils/number_helper.dart';
import 'package:provider/provider.dart';

class SubmitFormTicketPriceDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SubmitFormProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 20.0, bottom: 8.0, left: 20.0),
          child: Subtitle(
            title: 'Price Details',
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          color: ThemeColors.black0,
          child: Column(
            children: <Widget>[
              singleRowTitleValue(provider.singlePaxPrice,
                  '${provider.basicPrice == 0 ? 'Free' : getFormattedCurrency(provider.basicPrice)}',
                  isNeedGrey: true),
              divider(),
              singleRowTitleValue('Service Fee',
                  '${provider.servicePrice == 0 ? 'Free' : getFormattedCurrency(provider.servicePrice)}',
                  isNeedGrey: true),
              Visibility(
                visible: provider.isCouponActive,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    divider(),
                    singleRowTitleValue('Coupon',
                        '- ${getFormattedCurrency(provider.couponDiscount)}')
                  ],
                ),
              ),
              Visibility(
                visible: provider.isLocalPointActive,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    divider(),
                    singleRowTitleValue('Local Point',
                        '- ${getFormattedCurrency(provider.localPointDiscount)}')
                  ],
                ),
              ),
              divider(),
              singleRowTitleValue('Total Price',
                  '${provider.totalPrice == 0 ? 'Free' : getFormattedCurrency(provider.totalPrice)}')
            ],
          ),
        )
      ],
    );
  }

  singleRowTitleValue(String title, String value, {bool isNeedGrey = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          '$title',
          style: isNeedGrey
              ? ThemeText.sfMediumHeadline.copyWith(color: ThemeColors.black80)
              : ThemeText.sfSemiBoldHeadline,
        ),
        Text(
          '$value',
          style: isNeedGrey
              ? ThemeText.sfMediumHeadline.copyWith(color: ThemeColors.black80)
              : ThemeText.sfSemiBoldHeadline,
        )
      ],
    );
  }

  divider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: DashedLine(
        color: ThemeColors.black20,
        height: 1.5,
      ),
    );
  }
}
