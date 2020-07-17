import 'package:flutter/material.dart';
import 'package:localin/model/transaction/transaction_explore_detail_response.dart';
import 'package:localin/presentation/news/widgets/comments/parent_comment_card.dart';
import 'package:localin/presentation/shared_widgets/subtitle.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:localin/utils/number_helper.dart';

class ExplorePriceDetailWidget extends StatelessWidget {
  final Data exploreDetail;
  ExplorePriceDetailWidget({@required this.exploreDetail});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
              top: 24.0, bottom: 8.0, left: 20.0, right: 20.0),
          child: Subtitle(
            title: 'PRICE DETAIL',
          ),
        ),
        Container(
          width: double.maxFinite,
          color: ThemeColors.black0,
          margin: EdgeInsets.only(top: 4.0),
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _singleRowPriceWidget('${exploreDetail?.event?.eventName}',
                  '${getFormattedCurrency(exploreDetail?.invoiceTotal)}'),
              _divider(),
              _singleRowPriceWidget('Admin Fee',
                  '${getFormattedCurrency(exploreDetail?.adminFee)}'),
              _divider(),
              _singleRowPriceWidget('Total',
                  '${getFormattedCurrency(exploreDetail?.totalPayment)}')
            ],
          ),
        ),
      ],
    );
  }

  _divider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: DashedLine(
        color: ThemeColors.black20,
      ),
    );
  }

  _singleRowPriceWidget(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: Text(
            '$title',
            style: ThemeText.sfMediumHeadline,
          ),
        ),
        SizedBox(width: 15.0),
        Text('$value',
            style: ThemeText.sfMediumBody.copyWith(color: ThemeColors.orange))
      ],
    );
  }
}
