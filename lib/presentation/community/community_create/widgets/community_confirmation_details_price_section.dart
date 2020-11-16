import 'package:flutter/material.dart';
import 'package:localin/presentation/community/provider/create/community_type_provider.dart';
import 'package:localin/presentation/news/widgets/comments/parent_comment_card.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:localin/utils/constants.dart';
import 'package:localin/utils/number_helper.dart';
import 'package:provider/provider.dart';

class CommunityConfirmationDetailsPriceSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CommunityTypeProvider>(
      builder: (_, provider, __) {
        return Container(
          color: ThemeColors.black0,
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              buildSingleDetail('Komunitas',
                  '${provider.typeCommunity == kFreeCommunity ? 'Free' : getFormattedCurrency(provider.priceModel?.basicFare)}'),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 14.0),
                child: DashedLine(
                  color: ThemeColors.black20,
                ),
              ),
              buildSingleDetail('Admin Fee',
                  '${provider.typeCommunity == kFreeCommunity ? 'Free' : getFormattedCurrency(provider.priceModel?.adminFare)}'),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 14.0),
                child: DashedLine(
                  color: ThemeColors.black20,
                ),
              ),
              buildSingleDetail('Total',
                  '${provider.typeCommunity == kFreeCommunity ? 'Free' : getFormattedCurrency(provider.priceModel?.totalFare)}')
            ],
          ),
        );
      },
    );
  }

  Widget buildSingleDetail(String text, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(text, style: ThemeText.sfMediumHeadline),
        Text(
          value,
          style: ThemeText.sfMediumBody.copyWith(color: ThemeColors.orange),
        ),
      ],
    );
  }
}
