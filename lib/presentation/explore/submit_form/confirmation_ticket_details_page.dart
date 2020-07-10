import 'package:flutter/material.dart';
import 'package:localin/components/custom_app_bar.dart';

import '../../../text_themes.dart';
import '../../../themes.dart';

class ConfirmationTicketDetailsPage extends StatelessWidget {
  static const routeName = 'ConfirmationTicketDetailsPage';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.black0,
      appBar: CustomAppBar(
        appBar: AppBar(),
        titleStyle: ThemeText.sfMediumHeadline,
        pageTitle: 'Confirmation Details',
        leadingIcon: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: Icon(
            Icons.arrow_back,
            color: ThemeColors.black100,
          ),
        ),
      ),
      bottomNavigationBar: InkWell(
        onTap: () {},
        child: Container(
          height: 48.0,
          alignment: FractionalOffset.center,
          decoration: BoxDecoration(
            color: ThemeColors.primaryBlue,
          ),
          child: Text(
            'Confirm Booking',
            style: ThemeText.rodinaTitle3.copyWith(color: ThemeColors.black0),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            singleConfirmationRow(
                'Ticket', 'The Wave Pondok Indah Waterpark Tickets'),
            singleConfirmationRow('Date', 'Wed, 03 June 2020'),
            Divider(
              thickness: 1.5,
              color: ThemeColors.black20,
            ),
            singleConfirmationRow('Ticket 1', 'eman'),
            singleConfirmationRow('Ticket 2', 'eman'),
            singleConfirmationRow('Ticket 3', 'eman'),
            Divider(
              thickness: 1.5,
              color: ThemeColors.black20,
            ),
            singleConfirmationRow('Ticket (3)', 'IDR 267.000'),
            singleConfirmationRow('Admin Fee', 'IDR 0'),
            singleConfirmationRow('Total Amount', 'IDR 267.000'),
          ],
        ),
      ),
    );
  }

  Widget singleConfirmationRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title,
            style:
                ThemeText.sfMediumFootnote.copyWith(color: ThemeColors.black80),
          ),
          Text(value, style: ThemeText.sfMediumFootnote),
        ],
      ),
    );
  }
}
