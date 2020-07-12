import 'package:flutter/material.dart';
import 'package:localin/presentation/explore/book_ticket/book_ticket_list_selection_provider.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:localin/utils/number_helper.dart';
import 'package:provider/provider.dart';

class SubtotalTicketButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  SubtotalTicketButtonWidget({this.onPressed});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BookTicketListSelectionProvider>(context);
    return Container(
      height: 72.0,
      color: ThemeColors.black0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '${getFormattedCurrency(provider.getTotalPriceTicket())}',
                  style: ThemeText.sfSemiBoldHeadline
                      .copyWith(color: ThemeColors.orange),
                ),
                SizedBox(height: 4.0),
                Text(
                  '${provider.getTotalSelectedTicket()} tickets',
                  style: ThemeText.sfSemiBoldFootnote
                      .copyWith(color: ThemeColors.black60),
                )
              ],
            ),
            InkWell(
              onTap: onPressed,
              child: Container(
                decoration: BoxDecoration(
                  color: ThemeColors.primaryBlue,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 20.0),
                  child: Text(
                    'Continue',
                    style: ThemeText.rodinaTitle3
                        .copyWith(color: ThemeColors.black0),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
