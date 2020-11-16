import 'package:flutter/material.dart';
import 'package:localin/model/explore/single_person_form_model.dart';
import 'package:localin/presentation/explore/submit_form/widgets/single_confirmation_row.dart';
import 'package:localin/presentation/explore/submit_form/widgets/title_grey_section.dart';

class ConfirmationVisitorDetail extends StatelessWidget {
  final List<SinglePersonFormModel> eventRequestForm;

  ConfirmationVisitorDetail({this.eventRequestForm});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleGreySection(title: 'Visitor details (For E-ticket)'),
        Column(
            children: List.generate(eventRequestForm.length, (index) {
          return SingleConfirmationRow(
              'Ticket ${index + 1} (${eventRequestForm[index]?.ticketType})',
              eventRequestForm[index]?.name);
        })),
      ],
    );
  }
}
