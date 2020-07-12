import 'package:flutter/material.dart';
import 'package:localin/components/user_profile_box_widget.dart';
import 'package:localin/presentation/explore/shared_widgets/event_date_widget.dart';
import 'package:localin/presentation/explore/submit_form/submit_form_provider.dart';
import 'package:localin/presentation/shared_widgets/subtitle.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

class SubmitFormTicketDescription extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SubmitFormProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 20.0, bottom: 8.0, left: 20.0),
          child: Subtitle(
            title: 'Ticket',
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          color: ThemeColors.black0,
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  UserProfileImageWidget(
                    width: 62.0,
                    height: 62.0,
                    imageUrl: provider.eventSubmissionDetails.eventImage,
                  ),
                  SizedBox(width: 20.0),
                  Expanded(
                    child: Text(
                      '${provider.eventSubmissionDetails.eventName}',
                      style: ThemeText.rodinaTitle3,
                    ),
                  )
                ],
              ),
              SizedBox(height: 12.0),
              EventDateWidget(
                dateTime: '${provider.eventSubmissionDetails.eventDate}',
              ),
            ],
          ),
        )
      ],
    );
  }
}
