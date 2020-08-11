import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localin/presentation/revamp_hotel/hotel_detail_page/hotel_detail_revamp_page.dart';
import 'package:localin/presentation/revamp_hotel/hotel_list_page/provider/hotel_list_filter_provider.dart';
import 'package:localin/presentation/revamp_hotel/hotel_list_page/provider/hotel_list_provider.dart';
import 'package:localin/presentation/revamp_hotel/hotel_list_page/widgets/appbar_detail_content_widget.dart';
import 'package:localin/presentation/revamp_hotel/hotel_list_page/widgets/hotel_list_filter_builder.dart';
import 'package:localin/presentation/revamp_hotel/hotel_list_page/widgets/hotel_list_floating_bottom_widget.dart';
import 'package:localin/presentation/revamp_hotel/hotel_list_page/widgets/hotel_single_row_widget.dart';
import 'package:localin/presentation/revamp_hotel/hotel_list_page/widgets/quick_search_row_widget.dart';
import 'package:localin/text_themes.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../../themes.dart';

class HotelListPage extends StatelessWidget {
  static const routeName = 'HotelListPage';
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<HotelListProvider>(
          create: (_) => HotelListProvider(),
        ),
        ChangeNotifierProvider<HotelListFilterProvider>(
          create: (_) => HotelListFilterProvider(),
        )
      ],
      child: HotelListBuilder(),
    );
  }
}

class HotelListBuilder extends StatefulWidget {
  @override
  _HotelListBuilderState createState() => _HotelListBuilderState();
}

class _HotelListBuilderState extends State<HotelListBuilder> {
  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      minHeight: 0.0,
      controller: Provider.of<HotelListProvider>(context).panelController,
      maxHeight: MediaQuery.of(context).size.height,
      isDraggable: false,
      panel: HotelListFilterBuilder(),
      body: Scaffold(
        backgroundColor: ThemeColors.black10,
        appBar: AppBar(
          backgroundColor: ThemeColors.black0,
          title: Consumer<HotelListProvider>(
            builder: (_, provider, __) {
              return provider.showSearchAppBar
                  ? AppBarDetailContentWidget()
                  : Text(
                      'Stay',
                      style: ThemeText.sfMediumHeadline,
                    );
            },
          ),
          titleSpacing: 0.0,
          leading: InkWell(
            onTap: () => Navigator.of(context).pop(),
            child: Icon(Icons.arrow_back, color: ThemeColors.black80),
          ),
          actions: <Widget>[
            Consumer<HotelListProvider>(
              builder: (_, provider, __) {
                return Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: ValueListenableBuilder<Iterable<ItemPosition>>(
                      valueListenable:
                          provider.itemPositionedListener.itemPositions,
                      builder: (context, positioned, _) {
                        bool isShowAppBar = false;
                        if (positioned.isNotEmpty) {
                          isShowAppBar = positioned.first.index > 0;
                        }
                        if (isShowAppBar) {
                          return InkResponse(
                              highlightColor: ThemeColors.primaryBlue,
                              onTap: () async {},
                              child:
                                  SvgPicture.asset('images/search_grey.svg'));
                        } else {
                          return InkResponse(
                            highlightColor: ThemeColors.primaryBlue,
                            onTap: () async {
                              provider.scrollController.scrollTo(
                                  index: 3,
                                  duration: Duration(milliseconds: 400),
                                  curve: Curves.easeIn);
                            },
                            child: SvgPicture.asset('images/bookmark_full.svg',
                                color: ThemeColors.primaryBlue),
                          );
                        }
                      }),
                );
              },
            )
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: HotelListFloatingBottomWidget(),
        body: Consumer<HotelListProvider>(
          builder: (_, provider, __) {
            return ScrollablePositionedList.builder(
              itemCount: 4,
              itemScrollController: provider.scrollController,
              itemPositionsListener: provider.itemPositionedListener,
              padding: const EdgeInsets.only(bottom: 80.0),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return QuickSearchRowWidget();
                } else {
                  return InkResponse(
                      onTap: () => Navigator.of(context)
                          .pushNamed(HotelRevampDetailPage.routeName),
                      child: HotelSingleRowWidget());
                }
              },
            );
          },
        ),
      ),
    );
  }
}
