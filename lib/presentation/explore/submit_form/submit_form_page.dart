import 'package:flutter/material.dart';
import 'package:localin/components/custom_app_bar.dart';
import 'package:localin/components/custom_toast.dart';
import 'package:localin/components/user_profile_box_widget.dart';
import 'package:localin/presentation/explore/shared_widgets/event_date_widget.dart';
import 'package:localin/presentation/explore/submit_form/confirmation_ticket_details_page.dart';
import 'package:localin/presentation/explore/submit_form/submit_form_provider.dart';
import 'package:localin/presentation/explore/submit_form/widgets/submit_form_ticket_description.dart';
import 'package:localin/presentation/explore/submit_form/widgets/submit_form_ticket_price_details.dart';
import 'package:localin/presentation/explore/submit_form/widgets/submit_form_ticket_visitor.dart';
import 'package:localin/presentation/news/widgets/comments/parent_comment_card.dart';
import 'package:localin/presentation/shared_widgets/subtitle.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

class SubmitFormPage extends StatelessWidget {
  static const routeName = 'SubmitFormPage';
  static const eventSubmissionDetail = 'eventSubmissionDetail';
  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    return ChangeNotifierProvider<SubmitFormProvider>(
      create: (_) => SubmitFormProvider(routeArgs[eventSubmissionDetail]),
      child: SubmitFormContent(),
    );
  }
}

class SubmitFormContent extends StatelessWidget {
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
      bottomNavigationBar: Consumer<SubmitFormProvider>(
        builder: (context, provider, _) {
          return InkWell(
            onTap: () async {
              if (provider.isButtonNotActive) {
                CustomToast.showCustomBookmarkToast(
                    context, 'fill in user details',
                    duration: 2);
                return;
              }
              final result = await provider.orderTicket();
            },
            child: Container(
              height: 48.0,
              alignment: FractionalOffset.center,
              decoration: BoxDecoration(
                color: ThemeColors.primaryBlue,
              ),
              child: Text(
                'Continue',
                style:
                    ThemeText.rodinaTitle3.copyWith(color: ThemeColors.black0),
              ),
            ),
          );
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SubmitFormTicketDescription(),
            SubmitFormTicketVisitor(),
            SubmitFormTicketPriceDetails(),
          ],
        ),
      ),
    );
  }
}
