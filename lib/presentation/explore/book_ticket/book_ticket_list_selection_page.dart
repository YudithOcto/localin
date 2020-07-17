import 'package:flutter/material.dart';
import 'package:localin/components/custom_toast.dart';
import 'package:localin/model/explore/explore_event_detail.dart';
import 'package:localin/presentation/explore/book_ticket/book_ticket_list_selection_provider.dart';
import 'package:localin/presentation/explore/detail_page/provider/ticket_availability_provider.dart';
import 'package:localin/presentation/explore/enum.dart';
import 'package:localin/presentation/explore/shared_widgets/row_ticket_selection_quantity_widget.dart';
import 'package:localin/presentation/explore/shared_widgets/subtotal_ticket_bottom_widget.dart';
import 'package:localin/presentation/explore/submit_form/submit_form_page.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:localin/utils/number_helper.dart';
import 'package:provider/provider.dart';

class BookTicketListSelectionPage extends StatelessWidget {
  static const routeName = 'BookTicketPage';
  static const eventDetail = 'eventDetail';
  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    ExploreEventDetail item = routeArgs[eventDetail];
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<TicketAvailabilityProvider>(
          create: (_) => TicketAvailabilityProvider(item.idEvent),
        ),
        ChangeNotifierProxyProvider<TicketAvailabilityProvider,
            BookTicketListSelectionProvider>(
          create: (_) => BookTicketListSelectionProvider(detail: item),
          update: (_, data, bookNotifier) => bookNotifier
            ..addAvailableTickets(data.eventTicketList, data.maxQuantity),
        ),
      ],
      child: BookTicketListSelectionContent(),
    );
  }
}

class BookTicketListSelectionContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ticketAvailabilityProvider =
        Provider.of<TicketAvailabilityProvider>(context);
    return Scaffold(
      backgroundColor: ThemeColors.black10,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: ThemeColors.black0,
        leading: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: Icon(
            Icons.arrow_back,
            color: ThemeColors.black80,
          ),
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
      bottomNavigationBar: Consumer<BookTicketListSelectionProvider>(
        builder: (context, provider, _) {
          return SubtotalTicketButtonWidget(
            totalSelectedTicket: provider.totalSelectedTicket,
            totalTicketPrice: getFormattedCurrency(provider.totalPriceTicket),
            onPressed: () {
              if (provider.totalSelectedTicket > 0) {
                final data = provider.eventSubmissionDetail;
                Navigator.of(context)
                    .pushNamed(SubmitFormPage.routeName, arguments: {
                  SubmitFormPage.eventSubmissionDetail: data,
                });
              } else {
                CustomToast.showCustomBookmarkToast(
                    context, 'You need to select at least one ticket');
              }
            },
          );
        },
      ),
      body: StreamBuilder<shareExploreState>(
          stream: ticketAvailabilityProvider.calendarStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.hasData &&
                  snapshot.data == shareExploreState.success) {
                return Consumer<BookTicketListSelectionProvider>(
                  builder: (context, provider, _) {
                    return ListView.builder(
                      itemCount: provider.availableTickets.length,
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemBuilder: (context, index) {
                        final item = provider.availableTickets[index];
                        return RowTicketSelectionQuantityWidget(
                          ticketType: item.ticketType,
                          price: item.price,
                          onAddPressed: () {
                            final result = provider.addQuantity(
                                item.idTicket, item.maxBuyQty);
                            if (result.isNotEmpty) {
                              CustomToast.showCustomBookmarkToast(
                                  context, result,
                                  duration: 2);
                            }
                          },
                          onSubtractPressed: () {
                            provider.subtractQuantity(item.idTicket);
                          },
                          quantityIndicator:
                              provider.getCurrentTicketQuantity(item.idTicket),
                        );
                      },
                    );
                  },
                );
              } else {
                return Container();
              }
            }
          }),
    );
  }
}
