import 'package:flutter/material.dart';
import 'package:localin/components/custom_app_bar.dart';
import 'package:localin/components/custom_dialog.dart';
import 'package:localin/components/custom_toast.dart';
import 'package:localin/model/transaction/admin_fee_response_model.dart';
import 'package:localin/presentation/explore/submit_form/confirmation_ticket_details_page.dart';
import 'package:localin/presentation/explore/submit_form/providers/submit_form_provider.dart';
import 'package:localin/presentation/explore/submit_form/widgets/submit_form_ticket_description.dart';
import 'package:localin/presentation/explore/submit_form/widgets/submit_form_ticket_price_details.dart';
import 'package:localin/presentation/explore/submit_form/widgets/submit_form_ticket_visitor.dart';
import 'package:localin/presentation/shared_widgets/coupon_code_row_widget.dart';
import 'package:localin/provider/auth_provider.dart';
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
    final model = Provider.of<AuthProvider>(context);
    return ChangeNotifierProvider<SubmitFormProvider>(
      create: (_) => SubmitFormProvider(
          routeArgs[eventSubmissionDetail], model.userModel.username),
      child: SubmitFormContent(),
    );
  }
}

class SubmitFormContent extends StatefulWidget {
  @override
  _SubmitFormContentState createState() => _SubmitFormContentState();
}

class _SubmitFormContentState extends State<SubmitFormContent> {
  bool _isInit = true;
  Future getPrice;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      getPrice =
          Provider.of<SubmitFormProvider>(context, listen: false).getAdminFee();
      _isInit = false;
    }
    super.didChangeDependencies();
  }

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
                return;
              }
              final navigate =
                  await CustomDialog.showCustomDialogStaticVerticalButton(
                context,
                title: 'Confirm Order',
                okText: 'Order',
                message: 'Do you want to order this ticket ?',
                cancelText: 'Cancel',
                onCancel: () => Navigator.of(context).pop(),
                okCallback: () async {
                  Navigator.of(context).pop('ok');
                },
              );

              if (navigate != null && navigate == 'ok') {
                CustomDialog.showLoadingDialog(context,
                    message: 'Creating order  ...');
                final result = await provider.orderTicket();
                CustomDialog.closeDialog(context);
                CustomToast.showCustomBookmarkToast(context, result?.message);
                if (!result.error) {
                  Navigator.of(context).pushNamed(
                      ConfirmationTicketDetailsPage.routeName,
                      arguments: {
                        ConfirmationTicketDetailsPage.basicOrderInfo:
                            provider.eventSubmissionDetails,
                        ConfirmationTicketDetailsPage.orderVisitorsName:
                            provider.eventFormPersonNam,
                        ConfirmationTicketDetailsPage.orderApiReturned:
                            result.data,
                        ConfirmationTicketDetailsPage.priceDataInfo:
                            provider.priceData,
                        ConfirmationTicketDetailsPage.singleTax:
                            provider.servicePrice,
                      });
                }
              }
            },
            child: Container(
              height: 48.0,
              alignment: FractionalOffset.center,
              decoration: BoxDecoration(
                color: ThemeColors.primaryBlue,
              ),
              child: Text(
                'Confirm Booking',
                style:
                    ThemeText.rodinaTitle3.copyWith(color: ThemeColors.black0),
              ),
            ),
          );
        },
      ),
      body: FutureBuilder<AdminFeeResponseModel>(
          future: getPrice,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              return SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SubmitFormTicketDescription(),
                    SubmitFormTicketVisitor(),
                    Consumer<SubmitFormProvider>(
                      builder: (_, provider, __) => CouponCodeRowWidget(
                        onChanged: (s) {
                          provider.addPriceData = s;
                        },
                        onAppliedParams: (v) {
                          provider.addParamsDiscount = v;
                        },
                        priceToBeCalculated: snapshot.data.adminFee +
                            provider.eventSubmissionDetails.totalPrice,
                      ),
                    ),
                    SubmitFormTicketPriceDetails(),
                  ],
                ),
              );
            }
          }),
    );
  }
}
