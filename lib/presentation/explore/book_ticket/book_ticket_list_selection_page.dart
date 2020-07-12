import 'package:flutter/material.dart';
import 'package:localin/components/custom_toast.dart';
import 'package:localin/presentation/explore/book_ticket/book_ticket_list_selection_provider.dart';
import 'package:localin/presentation/explore/shared_widgets/row_ticket_selection_quantity_widget.dart';
import 'package:localin/presentation/explore/shared_widgets/subtotal_ticket_bottom_widget.dart';
import 'package:localin/presentation/explore/submit_form/submit_form_page.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

class BookTicketListSelectionPage extends StatelessWidget {
  static const routeName = 'BookTicketPage';
  static const previousTicketList = 'PreviousTicketList';
  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    return ChangeNotifierProvider<BookTicketListSelectionProvider>(
      create: (_) =>
          BookTicketListSelectionProvider(routeArgs[previousTicketList]),
      child: BookTicketListSelectionContent(),
    );
  }
}

class BookTicketListSelectionContent extends StatelessWidget {
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
        onPressed: () {
          if (Provider.of<BookTicketListSelectionProvider>(context)
                  .getTotalSelectedTicket() >
              0) {
            final data = Provider.of<BookTicketListSelectionProvider>(context)
                .eventSubmissionDetail;
            Navigator.of(context)
                .pushNamed(SubmitFormPage.routeName, arguments: {
              SubmitFormPage.eventSubmissionDetail: data,
            });
          } else {
            CustomToast.showCustomBookmarkToast(
                context, 'You need to select at least one ticket');
          }
        },
      ),
      body: Consumer<BookTicketListSelectionProvider>(
        builder: (context, provider, _) {
          return ListView.builder(
            itemCount: provider.availableTickets.length,
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              return RowTicketSelectionQuantityWidget(
                ticketType: provider.availableTickets[index].ticketType,
                price: provider.availableTickets[index].price,
                onAddPressed: () {
                  provider.addQuantity(index);
                },
                onSubtractPressed: () {
                  provider.subtractQuantity(index);
                },
                quantityIndicator: provider.getCurrentTicketQuantity(index),
              );
            },
          );
        },
      ),
    );
  }
}
