import 'package:flutter/material.dart';
import 'package:localin/presentation/transaction/community/provider/transaction_list_provider.dart';
import 'package:localin/presentation/transaction/community/transaction_community_detail_page.dart';
import 'package:localin/presentation/transaction/community/widget/booking_detail_widget.dart';
import 'package:provider/provider.dart';

class TransactionCommunityListWidget extends StatefulWidget {
  @override
  _TransactionCommunityListWidgetState createState() =>
      _TransactionCommunityListWidgetState();
}

class _TransactionCommunityListWidgetState
    extends State<TransactionCommunityListWidget> {
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
    if (_scrollController.offset > _scrollController.position.maxScrollExtent) {
      loadData(isRefresh: false);
    }
  }

  loadData({bool isRefresh = true}) async {
    Provider.of<TransactionListProvider>(context, listen: false)
        .getCommunityTransaction(isRefresh: isRefresh);
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
                physics: ClampingScrollPhysics(),
                itemCount: provider.listCommunityTransaction.length + 1,
                itemBuilder: (context, index) {
                  if (snapshot.data == transactionState.empty) {
                    return Container();
                  } else if (index < provider.listCommunityTransaction.length) {
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                            TransactionCommunityDetailPage.routeName,
                            arguments: {
                              TransactionCommunityDetailPage.onBackPressedHome:
                                  false,
                              TransactionCommunityDetailPage.transactionId:
                                  provider.listCommunityTransaction[index]
                                      .transactionId,
                            });
                      },
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
}
