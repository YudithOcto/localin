import 'package:flutter/material.dart';
import 'package:localin/presentation/explore/submit_form/submit_form_provider.dart';
import 'package:localin/presentation/shared_widgets/subtitle.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

class SubmitFormTicketVisitor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 20.0, bottom: 8.0, left: 20.0),
          child: Subtitle(
            title: 'Visitor Detail',
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          color: ThemeColors.black0,
          child: Consumer<SubmitFormProvider>(
            builder: (context, provider, _) {
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: List.generate(
                      provider.totalSelectedTicket,
                      (index) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Ticket ${index + 1} (${provider.getTicketTitle(index)})',
                                style: ThemeText.sfSemiBoldCaption
                                    .copyWith(color: ThemeColors.black80),
                              ),
                              SizedBox(height: 10.0),
                              TextFormField(
                                controller: provider.visitorController[index],
                                decoration: InputDecoration(
                                    hintText: 'Enter Name',
                                    hintStyle: ThemeText.sfMediumHeadline
                                        .copyWith(color: ThemeColors.black80)),
                              ),
                              SizedBox(height: 12.0),
                            ],
                          )));
            },
          ),
        )
      ],
    );
  }
}
