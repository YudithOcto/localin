import 'package:flutter/material.dart';
import 'package:localin/components/custom_app_bar.dart';
import 'package:localin/components/user_profile_box_widget.dart';
import 'package:localin/presentation/explore/shared_widgets/event_date_widget.dart';
import 'package:localin/presentation/explore/submit_form/confirmation_ticket_details_page.dart';
import 'package:localin/presentation/news/widgets/comments/parent_comment_card.dart';
import 'package:localin/presentation/shared_widgets/subtitle.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';

class SubmitFormPage extends StatelessWidget {
  static const routeName = 'SubmitFormPage';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.black10,
      appBar: CustomAppBar(
        appBar: AppBar(),
        titleStyle: ThemeText.sfMediumHeadline,
        pageTitle: 'Fill in Details',
        leadingIcon: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: Icon(
            Icons.arrow_back,
            color: ThemeColors.black100,
          ),
        ),
      ),
      bottomNavigationBar: InkWell(
        onTap: () => Navigator.of(context)
            .pushNamed(ConfirmationTicketDetailsPage.routeName),
        child: Container(
          height: 48.0,
          alignment: FractionalOffset.center,
          decoration: BoxDecoration(
            color: ThemeColors.primaryBlue,
          ),
          child: Text(
            'Continue',
            style: ThemeText.rodinaTitle3.copyWith(color: ThemeColors.black0),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.only(top: 20.0, bottom: 8.0, left: 20.0),
                  child: Subtitle(
                    title: 'Ticket',
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 20.0),
                  color: ThemeColors.black0,
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          UserProfileImageWidget(
                            width: 62.0,
                            height: 62.0,
                          ),
                          SizedBox(width: 20.0),
                          Expanded(
                            child: Text(
                              'The Wave Pondok Indah Waterpark Tickets ',
                              style: ThemeText.rodinaTitle3,
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 12.0),
                      EventDateWidget(),
                    ],
                  ),
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.only(top: 20.0, bottom: 8.0, left: 20.0),
                  child: Subtitle(
                    title: 'Visitor Detail',
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 20.0),
                  color: ThemeColors.black0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: List.generate(
                        3,
                        (index) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(height: 12.0),
                                Text(
                                  'TICKET ${index + 1}',
                                  style: ThemeText.sfSemiBoldCaption
                                      .copyWith(color: ThemeColors.black80),
                                ),
                                SizedBox(height: 6.0),
                                TextFormField(
                                  decoration: InputDecoration(
                                    hintText: 'Enter Name',
                                    hintStyle: ThemeText.sfMediumHeadline
                                        .copyWith(color: ThemeColors.black80),
                                    border: InputBorder.none,
                                  ),
                                )
                              ],
                            )),
                  ),
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.only(top: 20.0, bottom: 8.0, left: 20.0),
                  child: Subtitle(
                    title: 'Price Details',
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 20.0),
                  color: ThemeColors.black0,
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Total Price',
                            style: ThemeText.sfSemiBoldHeadline,
                          ),
                          Text(
                            'IDR 267.000',
                            style: ThemeText.sfSemiBoldHeadline,
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: DashedLine(
                          color: ThemeColors.black20,
                          height: 1.5,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Pax (3) @IDR 98.000',
                            style: ThemeText.sfMediumBody
                                .copyWith(color: ThemeColors.black80),
                          ),
                          Text(
                            'IDR 267.000',
                            style: ThemeText.sfMediumBody
                                .copyWith(color: ThemeColors.black80),
                          )
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
