import 'package:flutter/material.dart';
import 'package:localin/components/custom_app_bar.dart';
import 'package:localin/components/custom_dialog.dart';
import 'package:localin/components/custom_toast.dart';
import 'package:localin/components/filled_button_default.dart';
import 'package:localin/model/community/community_detail.dart';
import 'package:localin/model/transaction/transaction_response_model.dart';
import 'package:localin/presentation/bottom_navigation/main_bottom_navigation.dart';
import 'package:localin/presentation/community/community_detail/community_detail_page.dart';
import 'package:localin/presentation/news/widgets/comments/parent_comment_card.dart';
import 'package:localin/presentation/shared_widgets/subtitle.dart';
import 'package:localin/presentation/shared_widgets/top_bar_transaction_status_widget.dart';
import 'package:localin/presentation/transaction/community/provider/transaction_community_provider.dart';
import 'package:localin/presentation/transaction/community/widget/row_price_widget.dart';
import 'package:localin/presentation/transaction/community/widget/booking_detail_widget.dart';
import 'package:localin/presentation/webview/webview_page.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/utils/constants.dart';
import 'package:localin/utils/countdown.dart';
import 'package:localin/utils/number_helper.dart';
import 'package:provider/provider.dart';

import '../../../themes.dart';

class TransactionCommunityDetailPage extends StatelessWidget {
  static const routeName = 'TransactionCommunityDetailPage';
  static const transactionId = 'transactionId';
  static const onBackPressedHome = 'onBackPressedHome';
  static const communitySlug = 'communitySlug';

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
  String _transactionId;
  bool _isNeedToBackHome = false;
  String _communitySlug;

  loadData() {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    _transactionId = routeArgs[TransactionCommunityDetailPage.transactionId];
    _communitySlug = routeArgs[TransactionCommunityDetailPage.communitySlug];
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

  List<Widget> getDialogWidget() {
    List<Widget> widgetList = List();
    widgetList.add(buttonDialog1());
    return widgetList;
  }

  Widget buttonDialog1() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamedAndRemoveUntil(
              CommunityDetailPage.routeName, (route) => false,
              arguments: {
                CommunityDetailPage.communityData: _communitySlug,
                CommunityDetailPage.needBackToHome: true,
              });
        },
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(4.0)),
          child: Text(
            'Close',
            textAlign: TextAlign.center,
            style: ThemeText.rodinaTitle3.copyWith(color: ThemeColors.black80),
          ),
        ),
      ),
    );
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
        final response = await Navigator.of(context)
            .pushNamed(WebViewPage.routeName, arguments: {
          WebViewPage.urlName: result?.urlRedirect,
          WebViewPage.title: 'Dana',
        });
        if (response != null && response == SUCCESS_VERIFICATION) {
          CustomDialog.showCustomDialogVerticalMultipleButton(context,
              dialogButtons: getDialogWidget(),
              title: 'Congratulations!',
              message:
                  'You have successfully create your own community. Invite your friends into your community.');
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

  @override
  void didChangeDependencies() {
    if (_isInit) {
      loadData();
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  onBackPressed() {
    if (_isNeedToBackHome) {
      Navigator.of(context).pushNamedAndRemoveUntil(
          MainBottomNavigation.routeName, (route) => false);
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        onBackPressed();
        return false;
      },
      child: Scaffold(
        backgroundColor: ThemeColors.black10,
        appBar: CustomAppBar(
          appBar: AppBar(),
          onClickBackButton: () {
            onBackPressed();
          },
          pageTitle: 'Purchase Details',
          titleStyle: ThemeText.sfMediumHeadline,
        ),
        bottomNavigationBar: Consumer<TransactionCommunityProvider>(
          builder: (context, provider, child) {
            return Visibility(
              visible: provider.transactionDetail?.status ==
                      kTransactionWaitingPayment ??
                  false,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        CustomDialog.showLoadingDialog(context,
                            message: 'Please wait');
                        final result =
                            await Provider.of<TransactionCommunityProvider>(
                                    context,
                                    listen: false)
                                .cancelTransaction(_transactionId);
                        CustomDialog.closeDialog(context);
                        CustomToast.showCustomBookmarkToast(context, result);
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        height: 48.0,
                        alignment: FractionalOffset.center,
                        decoration: BoxDecoration(
                          color: ThemeColors.black60,
                          borderRadius:
                              BorderRadius.only(topLeft: Radius.circular(4.0)),
                        ),
                        child: Text(
                          'Cancel',
                          textAlign: TextAlign.center,
                          style: ThemeText.rodinaTitle3
                              .copyWith(color: ThemeColors.black0),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: onPressedPayment,
                      child: Container(
                        height: 48.0,
                        alignment: FractionalOffset.center,
                        decoration: BoxDecoration(
                          color: ThemeColors.primaryBlue,
                          borderRadius:
                              BorderRadius.only(topRight: Radius.circular(4.0)),
                        ),
                        child: Text(
                          'Pay Now',
                          textAlign: TextAlign.center,
                          style: ThemeText.rodinaTitle3
                              .copyWith(color: ThemeColors.black0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        body: StreamBuilder<transactionCommunityState>(
          stream:
              Provider.of<TransactionCommunityProvider>(context, listen: false)
                  .transStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              final provider =
                  Provider.of<TransactionCommunityProvider>(context);
              if (provider.transactionDetail != null) {
                final item = provider.transactionDetail;
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TopBarTransactionStatusWidget(
                        backgroundColor: ThemeColors.orange,
                        status: item?.status,
                        expiredAt: item?.expiredAt,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 24.0, bottom: 8.0, left: 20.0, right: 20.0),
                        child: Subtitle(
                          title: 'BOOKING DETAIL',
                        ),
                      ),
                      BookingDetailWidget(
                        detail: item,
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
                              value: getFormattedCurrency(item?.basicPayment),
                            ),
                            DashedLine(
                              color: ThemeColors.black20,
                              height: 1.5,
                            ),
                            RowPriceWidget(
                              title: 'Admin Fee',
                              valueStyle: ThemeText.sfMediumBody.copyWith(
                                  color: item.adminFee > 0
                                      ? ThemeColors.orange
                                      : ThemeColors.black60),
                              value: getFormattedCurrency(item?.adminFee),
                            ),
                            DashedLine(
                              color: ThemeColors.black20,
                              height: 1.5,
                            ),
                            RowPriceWidget(
                              title: 'Total',
                              valueStyle: ThemeText.sfMediumBody
                                  .copyWith(color: ThemeColors.orange),
                              value: getFormattedCurrency(item?.totalPayment),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              } else {
                return Container();
              }
            }
          },
        ),
      ),
    );
  }
}
