import 'package:flutter/material.dart';
import 'package:localin/model/transaction/transaction_explore_detail_response.dart';
import 'package:localin/presentation/news/widgets/comments/parent_comment_card.dart';
import 'package:localin/presentation/shared_widgets/subtitle.dart';
import 'package:localin/text_themes.dart';

import '../../../../themes.dart';

class ExploreVisitorDetailWidget extends StatelessWidget {
  final Data exploreDetail;

  ExploreVisitorDetailWidget({@required this.exploreDetail});

  @override
  Widget build(BuildContext context) {
    if (exploreDetail == null && exploreDetail.attendees == null)
      return Container();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
              top: 24.0, bottom: 8.0, left: 20.0, right: 20.0),
          child: Subtitle(
            title: 'VISITOR DETAIL',
          ),
        ),
        Container(
          width: double.maxFinite,
          color: ThemeColors.black0,
          margin: EdgeInsets.only(top: 4.0),
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                exploreDetail?.attendees?.length,
                (index) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                        '${exploreDetail?.attendees[index]?.firstName} ${exploreDetail?.attendees[index]?.lastName}',
                        style: ThemeText.rodinaHeadline),
                    SizedBox(height: 5.0),
                    Text(
                        'Barcode ID: ${exploreDetail?.attendees[index]?.barcodeId}',
                        style: ThemeText.sfSemiBoldFootnote
                            .copyWith(color: ThemeColors.black80)),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 13.0),
                      child: DashedLine(
                        color: ThemeColors.black20,
                      ),
                    )
                  ],
                ),
              )),
        )
      ],
    );
  }
}
