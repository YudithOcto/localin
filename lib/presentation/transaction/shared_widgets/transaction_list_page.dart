import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localin/presentation/hotel/booking_history_page.dart';
import 'package:localin/presentation/transaction/community/provider/transaction_list_provider.dart';
import 'package:localin/presentation/transaction/shared_widgets/transaction_list_widget.dart';
import 'package:localin/presentation/transaction/provider/transaction_header_provider.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

class TransactionListPage extends StatelessWidget {
  static const routeName = 'transactionListPage';
  final int selectedHeaderIndex;
  TransactionListPage({this.selectedHeaderIndex});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<TransactionHeaderProvider>(
          create: (_) =>
              TransactionHeaderProvider(index: selectedHeaderIndex ?? 0),
        ),
      ],
      child: TransactionListPageWrapperWidget(),
    );
  }
}

class TransactionListPageWrapperWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          TransactionHeaderWidget(),
          Expanded(
            child: PageView(
              controller:
                  Provider.of<TransactionHeaderProvider>(context, listen: false)
                      .pageController,
              onPageChanged: (value) {
                Provider.of<TransactionHeaderProvider>(context, listen: false)
                    .selectedHeader = value;
              },
              children: <Widget>[
                BookingHistoryPage(),
                ChangeNotifierProvider<TransactionListProvider>(
                  create: (_) => TransactionListProvider(),
                  child: TransactionListWidget(
                    type: 'community',
                  ),
                ),
                ChangeNotifierProvider<TransactionListProvider>(
                  create: (_) => TransactionListProvider(),
                  child: TransactionListWidget(
                    type: 'explore',
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class TransactionHeaderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Image.asset(
          'images/news_base.png',
          fit: BoxFit.cover,
          width: double.infinity,
        ),
        Positioned(
          top: 42.0,
          left: 20.0,
          right: 0.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Transaction',
                style:
                    ThemeText.rodinaTitle1.copyWith(color: ThemeColors.black0),
              ),
              SizedBox(
                height: 12.0,
              ),
              Consumer<TransactionHeaderProvider>(
                builder: (context, provider, child) {
                  return Container(
                    height: 48.0,
                    child: ListView(
                        physics: ClampingScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        children:
                            List.generate(provider.iconTab.length, (index) {
                          return InkWell(
                            onTap: () => provider.selectedHeader = index,
                            child: Container(
                              margin:
                                  EdgeInsets.only(left: index == 0 ? 0 : 12.0),
                              alignment: FractionalOffset.center,
                              decoration: BoxDecoration(
                                  color: provider.currentHeaderSelected == index
                                      ? ThemeColors.black0
                                      : ThemeColors.black0.withAlpha(100),
                                  borderRadius: BorderRadius.circular(100.0)),
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SvgPicture.asset(
                                      provider.iconTab[index],
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 13.0),
                                    child: Text(
                                      provider.newsTabTitle[index],
                                      style: ThemeText.sfSemiBoldFootnote,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        })),
                  );
                },
              )
            ],
          ),
        ),
      ],
    );
  }
}
