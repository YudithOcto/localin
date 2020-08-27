import 'package:flutter/material.dart';
import 'package:localin/components/custom_toast.dart';
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
    bool isButtonActive = eventDetail != null &&
        eventDetail.schedulesCount != null &&
        eventDetail.schedulesCount > 0;
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
                      '${eventDetail?.startPrice == 0 ? 'Free' : getFormattedCurrency(eventDetail?.startPrice) ?? ''}',
                  style: ThemeText.rodinaTitle2
                      .copyWith(color: ThemeColors.orange)),
              TextSpan(text: '\t/ticket', style: ThemeText.sfMediumCaption),
            ]),
          ),
          InkWell(
            onTap: () {
              if (isButtonActive) {
                Navigator.of(context).pushNamed(
                    BookTicketListSelectionPage.routeName,
                    arguments: {
                      BookTicketListSelectionPage.eventDetail: eventDetail,
                    });
              } else {
                CustomToast.showCustomBookmarkToast(
                    context, 'There are no ticket available currently.');
              }
            },
            child: Container(
              decoration: BoxDecoration(
                  color: isButtonActive
                      ? ThemeColors.primaryBlue
                      : ThemeColors.black80,
                  borderRadius: BorderRadius.circular(4.0)),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 20.0),
                child: Text(
                  '${isButtonActive ? 'Buy' : 'Ticket Not Available'}',
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
