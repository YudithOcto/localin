import 'package:flutter/material.dart';
import 'package:localin/presentation/explore/shared_widgets/row_ticket_selection_quantity_widget.dart';
import 'package:localin/presentation/explore/shared_widgets/subtotal_ticket_bottom_widget.dart';
import 'package:localin/presentation/explore/submit_form/submit_form_page.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';

class BookTicketListSelectionPage extends StatelessWidget {
  static const routeName = 'BookTicketPage';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.black10,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: ThemeColors.black0,
        leading: Icon(
          Icons.arrow_back,
          color: ThemeColors.black80,
        ),
        titleSpacing: 0.0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Book Ticket',
              style: ThemeText.sfMediumHeadline,
            ),
            Text(
              'Total of visitors',
              style: ThemeText.sfMediumFootnote
                  .copyWith(color: ThemeColors.black80),
            )
          ],
        ),
      ),
      bottomNavigationBar: SubtotalTicketButtonWidget(
        onPressed: () =>
            Navigator.of(context).pushNamed(SubmitFormPage.routeName),
      ),
      body: RowTicketSelectionQuantityWidget(),
    );
  }
}
