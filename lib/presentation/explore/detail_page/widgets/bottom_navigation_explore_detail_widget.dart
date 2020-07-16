import 'package:flutter/material.dart';
import 'package:localin/presentation/explore/book_ticket/book_ticket_list_selection_page.dart';
import 'package:localin/presentation/explore/detail_page/provider/explore_event_detail_provider.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:localin/utils/number_helper.dart';
import 'package:provider/provider.dart';

class BottomNavigationExploreDetailWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final eventDetail =
        Provider.of<ExploreEventDetailProvider>(context).eventDetail;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          RichText(
            text: TextSpan(children: <TextSpan>[
              TextSpan(
                  text: 'Starting from\n', style: ThemeText.sfMediumCaption),
              TextSpan(
                  text:
                      '${getFormattedCurrency(eventDetail?.startPrice) ?? ''}',
                  style: ThemeText.rodinaTitle2
                      .copyWith(color: ThemeColors.orange)),
              TextSpan(text: '\t/ticket', style: ThemeText.sfMediumCaption),
            ]),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context)
                  .pushNamed(BookTicketListSelectionPage.routeName, arguments: {
                BookTicketListSelectionPage.eventDetail: eventDetail,
              });
            },
            child: Container(
              decoration: BoxDecoration(
                  color: ThemeColors.primaryBlue,
                  borderRadius: BorderRadius.circular(4.0)),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 20.0),
                child: Text(
                  'Buy',
                  style: ThemeText.rodinaTitle3
                      .copyWith(color: ThemeColors.black0),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
