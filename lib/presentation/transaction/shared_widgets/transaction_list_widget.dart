import 'package:flutter/material.dart';
import 'package:localin/model/transaction/transaction_response_model.dart';
import 'package:localin/presentation/transaction/community/provider/transaction_list_provider.dart';
import 'package:localin/presentation/transaction/community/transaction_community_detail_page.dart';
import 'package:localin/presentation/transaction/community/widget/booking_detail_widget.dart';
import 'package:localin/presentation/transaction/community/widget/transaction_empty_community_page.dart';
import 'package:localin/presentation/transaction/explore/transaction_explore_detail_page.dart';
import 'package:localin/presentation/transaction/explore/widgets/transaction_empty_explore_page.dart';
import 'package:localin/presentation/transaction/hotel/transaction_hotel_detail_page.dart';
import 'package:localin/presentation/transaction/hotel/widget/transaction_hotel_empty_widget.dart';
import 'package:localin/utils/constants.dart';
import 'package:provider/provider.dart';

class TransactionListWidget extends StatefulWidget {
  final String type;
  TransactionListWidget({this.type});

  @override
  _TransactionListWidgetState createState() => _TransactionListWidgetState();
}

class _TransactionListWidgetState extends State<TransactionListWidget> {
  final _scrollController = ScrollController();
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _scrollController..addListener(_pageListener);
      loadData();
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  _pageListener() {
    if (_scrollController.offset >=
        _scrollController.position.maxScrollExtent) {
      loadData(isRefresh: false);
    }
  }

  loadData({bool isRefresh = true}) async {
    Provider.of<TransactionListProvider>(context, listen: false)
        .getTransactionList(isRefresh: isRefresh, type: widget.type);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionListProvider>(
      builder: (context, provider, child) {
        return StreamBuilder<transactionState>(
          stream: provider.apiStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting &&
                provider.page <= 1) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView.separated(
                separatorBuilder: (context, index) => Divider(),
                shrinkWrap: true,
                controller: _scrollController,
                physics: ClampingScrollPhysics(),
                itemCount: provider.listCommunityTransaction.length + 1,
                itemBuilder: (context, index) {
                  if (snapshot.data == transactionState.empty) {
                    if (widget.type == 'explore') {
                      return TransactionEmptyExplorePage();
                    } else if (widget.type == 'community') {
                      return TransactionEmptyCommunityPage();
                    } else {
                      return TransactionHotelEmptyWidget();
                    }
                  } else if (index < provider.listCommunityTransaction.length) {
                    return InkWell(
                      onTap: () => navigateToDetailPage(
                          provider.listCommunityTransaction[index]),
                      child: BookingDetailWidget(
                        detail: provider.listCommunityTransaction[index],
                        showPaymentRow: true,
                      ),
                    );
                  } else if (provider.canLoadMore) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return Container();
                  }
                },
              );
            }
          },
        );
      },
    );
  }

  navigateToDetailPage(TransactionDetailModel item) async {
    if (item.transactionType == 'komunitas') {
      final result = await Navigator.of(context)
          .pushNamed(TransactionCommunityDetailPage.routeName, arguments: {
        TransactionCommunityDetailPage.onBackPressedHome: false,
        TransactionCommunityDetailPage.transactionId: item.transactionId,
        TransactionCommunityDetailPage.communitySlug:
            item.serviceDetail.communitySlug,
      });
      if (result != null && result == kRefresh) {
        loadData(isRefresh: true);
      }
    } else if (item.transactionType == 'loket') {
      final result = await Navigator.of(context).pushNamed(
        TransactionExploreDetailPage.routeName,
        arguments: {
          TransactionExploreDetailPage.transactionId: item.transactionId
        },
      );
      if (result != null && result == kRefresh) {
        loadData(isRefresh: true);
      }
    } else {
      final result = await Navigator.of(context)
          .pushNamed(TransactionHotelDetailPage.routeName, arguments: {
        TransactionHotelDetailPage.bookingId: item.transactionId,
        TransactionHotelDetailPage.fromSuccessPage: false,
      });
      if (result != null && result == kRefresh) {
        loadData(isRefresh: true);
      }
    }
  }
}
