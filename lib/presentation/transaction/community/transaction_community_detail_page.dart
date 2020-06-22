import 'package:flutter/material.dart';
import 'package:localin/components/custom_app_bar.dart';
import 'package:localin/components/custom_dialog.dart';
import 'package:localin/components/filled_button_default.dart';
import 'package:localin/model/transaction/transaction_response_model.dart';
import 'package:localin/presentation/bottom_navigation/main_bottom_navigation.dart';
import 'package:localin/presentation/news/widgets/comments/parent_comment_card.dart';
import 'package:localin/presentation/shared_widgets/subtitle.dart';
import 'package:localin/presentation/shared_widgets/top_bar_transaction_status_widget.dart';
import 'package:localin/presentation/transaction/community/provider/transaction_community_provider.dart';
import 'package:localin/presentation/transaction/community/widget/row_price_widget.dart';
import 'package:localin/presentation/transaction/community/widget/booking_detail_widget.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/utils/countdown.dart';
import 'package:localin/utils/number_helper.dart';
import 'package:provider/provider.dart';

import '../../../themes.dart';

class TransactionCommunityDetailPage extends StatelessWidget {
  static const routeName = 'TransactionCommunityDetailPage';
  static const transactionId = 'transactionId';
  static const onBackPressedHome = 'onBackPressedHome';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TransactionCommunityProvider(),
      child: TransactionCommunityContentWidget(),
    );
  }
}

class TransactionCommunityContentWidget extends StatefulWidget {
  @override
  _TransactionCommunityContentWidgetState createState() =>
      _TransactionCommunityContentWidgetState();
}

class _TransactionCommunityContentWidgetState
    extends State<TransactionCommunityContentWidget> {
  bool _isInit = true;
  Future getTransactionData;
  Countdown _countdown;
  String _transactionId;
  bool _isNeedToBackHome = false;

  loadData() {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    _transactionId = routeArgs[TransactionCommunityDetailPage.transactionId];
    _isNeedToBackHome =
        routeArgs[TransactionCommunityDetailPage.onBackPressedHome] ?? false;
    getTransactionData =
        Provider.of<TransactionCommunityProvider>(context, listen: false)
            .getCommunityTransactionDetail(_transactionId);
  }

  onPressedPayment() async {
    await CustomDialog.showCustomDialogVerticalMultipleButton(context,
        dialogButtons: getButtonWidget(),
        title: 'Purchase',
        message: 'You will get more features by purchase');
  }

  List<Widget> getButtonWidget() {
    List<Widget> widget = List();
    widget.add(FilledButtonDefault(
      buttonText: 'OK',
      onPressed: () async {
        Navigator.of(context).pop();
        CustomDialog.showLoadingDialog(context, message: 'Please wait');
        final result = await Provider.of<TransactionCommunityProvider>(context,
                listen: false)
            .payTransaction(_transactionId);
        CustomDialog.closeDialog(context);
        final dialog = await CustomDialog.showCustomDialogWithButton(
            context, 'Purchase', result?.message);
        if (!result.error && dialog == 'success') {
          Navigator.of(context)
              .pushReplacementNamed(MainBottomNavigation.routeName);
        }
      },
      backgroundColor: ThemeColors.primaryBlue,
      textTheme: ThemeText.rodinaHeadline.copyWith(color: ThemeColors.black0),
    ));
    widget.add(InkWell(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        margin: EdgeInsets.only(top: 10.0),
        alignment: FractionalOffset.center,
        child: Text(
          'Cancel',
          style: ThemeText.rodinaHeadline,
        ),
      ),
    ));
    return widget;
  }

  startCountDown(DateTime expiredTime) {
    _countdown = Countdown(expiredTime: expiredTime);
    _countdown.run();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      loadData();
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _countdown.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_isNeedToBackHome) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              MainBottomNavigation.routeName, (route) => false);
        } else {
          Navigator.of(context).pop();
        }
        return false;
      },
      child: Scaffold(
        backgroundColor: ThemeColors.black10,
        appBar: CustomAppBar(
          appBar: AppBar(),
          onClickBackButton: () {
            if (_isNeedToBackHome) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  MainBottomNavigation.routeName, (route) => false);
            } else {
              Navigator.of(context).pop();
            }
          },
          pageTitle: 'Purchase Details',
          titleStyle: ThemeText.sfMediumHeadline,
        ),
        bottomNavigationBar: Row(
          children: <Widget>[
            Expanded(
              child: FilledButtonDefault(
                backgroundColor: ThemeColors.black60,
                textTheme:
                    ThemeText.rodinaTitle3.copyWith(color: ThemeColors.black0),
                buttonText: 'Cancel',
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            Expanded(
              child: FilledButtonDefault(
                buttonText: 'Pay Now',
                textTheme:
                    ThemeText.rodinaTitle3.copyWith(color: ThemeColors.black0),
                onPressed: onPressedPayment,
              ),
            ),
          ],
        ),
        body: FutureBuilder<TransactionCommunityResponseModel>(
          future: getTransactionData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              startCountDown(DateTime.parse(snapshot.data.data.expiredAt));

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TopBarTransactionStatusWidget(
                      backgroundColor: ThemeColors.orange,
                      childWidget: StreamBuilder<String>(
                          stream: _countdown.differenceStream,
                          builder: (context, snapshot) {
                            return Text(
                              'Waiting for payment \u2022 ${snapshot.data ?? '00:00'}',
                              textAlign: TextAlign.center,
                              style: ThemeText.sfMediumFootnote
                                  .copyWith(color: ThemeColors.black0),
                            );
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 24.0, bottom: 8.0, left: 20.0, right: 20.0),
                      child: Subtitle(
                        title: 'BOOKING DETAIL',
                      ),
                    ),
                    BookingDetailWidget(
                      detail: snapshot?.data?.data,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 24.0, bottom: 8.0, left: 20.0, right: 20.0),
                      child: Subtitle(
                        title: 'PRICE DETAIL',
                      ),
                    ),
                    Container(
                      color: ThemeColors.black0,
                      child: Column(
                        children: <Widget>[
                          RowPriceWidget(
                            title: 'Komunitas Pro',
                            valueStyle: ThemeText.sfMediumBody
                                .copyWith(color: ThemeColors.orange),
                            value: getFormattedCurrency(
                                snapshot.data.data.basicPayment),
                          ),
                          DashedLine(
                            color: ThemeColors.black20,
                            height: 1.5,
                          ),
                          RowPriceWidget(
                            title: 'Admin Fee',
                            valueStyle: ThemeText.sfMediumBody.copyWith(
                                color: snapshot.data.data.adminFee > 0
                                    ? ThemeColors.orange
                                    : ThemeColors.black60),
                            value: getFormattedCurrency(
                                snapshot.data.data.adminFee),
                          ),
                          DashedLine(
                            color: ThemeColors.black20,
                            height: 1.5,
                          ),
                          RowPriceWidget(
                            title: 'Total',
                            valueStyle: ThemeText.sfMediumBody
                                .copyWith(color: ThemeColors.orange),
                            value: getFormattedCurrency(
                                snapshot.data.data.totalPayment),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
