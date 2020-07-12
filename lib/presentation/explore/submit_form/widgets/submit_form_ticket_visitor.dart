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
                      provider.getTicketBySection,
                      (index) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Ticket (${provider.getTicketBySectionTitle(index)})',
                                style: ThemeText.sfSemiBoldHeadline,
                              ),
                              SizedBox(height: 10.0),
                              Column(
                                  children: List.generate(
                                      provider.getTicketTotalPerSection(provider
                                          .getTicketBySectionTitle(index)),
                                      (index) => Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                'TICKET ${index + 1}',
                                                style: ThemeText
                                                    .sfSemiBoldCaption
                                                    .copyWith(
                                                        color: ThemeColors
                                                            .black80),
                                              ),
                                              SizedBox(height: 2.0),
                                              TextFormField(
                                                decoration: InputDecoration(
                                                  hintText: 'Enter Name',
                                                  hintStyle: ThemeText
                                                      .sfMediumHeadline
                                                      .copyWith(
                                                          color: ThemeColors
                                                              .black80),
                                                  border: InputBorder.none,
                                                ),
                                              ),
                                            ],
                                          ))),
                              SizedBox(height: 20.0),
                            ],
                          )));
//              return Column(
//                crossAxisAlignment: CrossAxisAlignment.stretch,
//                children: List.generate(
//                    provider.eventSubmissionDetails.totalTicket,
//                    (index) => Column(
//                          crossAxisAlignment: CrossAxisAlignment.start,
//                          children: <Widget>[
//                            SizedBox(height: 12.0),
//                            Text(
//                              'TICKET ${index + 1} (${provider.generateTicketType})',
//                              style: ThemeText.sfSemiBoldCaption
//                                  .copyWith(color: ThemeColors.black80),
//                            ),
//                            SizedBox(height: 6.0),
//                            TextFormField(
//                              decoration: InputDecoration(
//                                hintText: 'Enter Name',
//                                hintStyle: ThemeText.sfMediumHeadline
//                                    .copyWith(color: ThemeColors.black80),
//                                border: InputBorder.none,
//                              ),
//                            )
//                          ],
//                        )),
//              );
            },
          ),
        )
      ],
    );
  }
}
