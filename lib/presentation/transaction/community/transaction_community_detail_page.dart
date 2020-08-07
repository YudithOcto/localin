import 'package:flutter/material.dart';
import 'package:localin/components/custom_app_bar.dart';
import 'package:localin/model/transaction/transaction_response_model.dart';
import 'package:localin/presentation/bottom_navigation/main_bottom_navigation.dart';
import 'package:localin/presentation/news/widgets/comments/parent_comment_card.dart';
import 'package:localin/presentation/shared_widgets/subtitle.dart';
import 'package:localin/presentation/shared_widgets/top_bar_transaction_status_widget.dart';
import 'package:localin/presentation/transaction/provider/transaction_detail_provider.dart';
import 'package:localin/presentation/transaction/community/widget/row_price_widget.dart';
import 'package:localin/presentation/transaction/community/widget/booking_detail_widget.dart';
import 'package:localin/presentation/transaction/shared_widgets/bottom_button_payment_widget.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/utils/constants.dart';
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
    return ChangeNotifierProvider<TransactionDetailProvider>(
      create: (_) => TransactionDetailProvider(),
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

  loadData() {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    _transactionId = routeArgs[TransactionCommunityDetailPage.transactionId];
    _isNeedToBackHome =
        routeArgs[TransactionCommunityDetailPage.onBackPressedHome] ?? false;
    getTransactionData =
        Provider.of<TransactionDetailProvider>(context, listen: false)
            .getTransactionDetail(_transactionId, kTransactionTypeCommunity);
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
      final provider = Provider.of<TransactionDetailProvider>(context);
      if (provider.isNavigateBackNeedRefresh) {
        Navigator.of(context).pop(kRefresh);
      } else {
        Navigator.of(context).pop();
      }
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
        bottomNavigationBar: Consumer<TransactionDetailProvider>(
          builder: (__, provider, _) {
            final item =
                provider.transactionDetail as TransactionCommunityDetail;
            return item == null
                ? Container()
                : BottomButtonPaymentWidget(
                    isVisible:
                        item?.status == kTransactionWaitingPayment ?? false,
                    transactionId: item.transactionId,
                    type: kTransactionTypeCommunity,
                  );
          },
        ),
        body: StreamBuilder<transactionDetailState>(
          stream: Provider.of<TransactionDetailProvider>(context, listen: false)
              .transStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              final provider = Provider.of<TransactionDetailProvider>(context);
              if (provider.transactionDetail != null) {
                TransactionCommunityDetail item = provider.transactionDetail;
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
