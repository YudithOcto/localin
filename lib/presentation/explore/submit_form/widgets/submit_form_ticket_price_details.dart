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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total Price',
                    style: ThemeText.sfSemiBoldHeadline,
                  ),
                  Text(
                    '${getFormattedCurrency(provider.eventSubmissionDetails.totalPrice)}',
                    style: ThemeText.sfSemiBoldHeadline,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '${provider.singlePaxPrice}',
                    style: ThemeText.sfMediumBody
                        .copyWith(color: ThemeColors.black80),
                  ),
                  Text(
                    '${getFormattedCurrency(provider.eventSubmissionDetails.totalPrice)}',
                    style: ThemeText.sfMediumBody
                        .copyWith(color: ThemeColors.black80),
                  )
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
