import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localin/presentation/revamp_hotel/hotel_bookmark_page/hotel_bookmark_page.dart';
import 'package:localin/presentation/revamp_hotel/hotel_detail_page/hotel_detail_revamp_page.dart';
import 'package:localin/presentation/revamp_hotel/hotel_list_page/provider/hotel_list_provider.dart';
import 'package:localin/presentation/revamp_hotel/hotel_list_page/widgets/appbar_detail_content_widget.dart';
import 'package:localin/presentation/revamp_hotel/hotel_list_page/widgets/hotel_list_filter_builder.dart';
import 'package:localin/presentation/revamp_hotel/hotel_list_page/widgets/hotel_list_floating_bottom_widget.dart';
import 'package:localin/presentation/revamp_hotel/hotel_list_page/widgets/quick_search_row_widget.dart';
import 'package:localin/presentation/revamp_hotel/shared_widgets/hotel_single_row_widget.dart';
import 'package:localin/presentation/search/provider/generic_provider.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class HotelListBuilder extends StatefulWidget {
  @override
  _HotelListBuilderState createState() => _HotelListBuilderState();
}

class _HotelListBuilderState extends State<HotelListBuilder> {
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<HotelListProvider>(context, listen: false)
          .getRestaurantList();
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      minHeight: 0.0,
      controller: Provider.of<HotelListProvider>(context).panelController,
      maxHeight: MediaQuery.of(context).size.height,
      isDraggable: false,
      panel: HotelListFilterBuilder(),
      body: StreamBuilder<bool>(
          stream: Provider.of<HotelListProvider>(context, listen: false)
              .appbarStream,
          builder: (context, snapshot) {
            return Scaffold(
              backgroundColor: ThemeColors.black10,
              appBar: AppBar(
                backgroundColor: ThemeColors.black0,
                title:
                    snapshot != null && snapshot.data != null && snapshot.data
                        ? AppBarDetailContentWidget()
                        : Text(
                            'Stay',
                            style: ThemeText.sfMediumHeadline,
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
                        child: snapshot != null &&
                                snapshot.data != null &&
                                snapshot.data
                            ? InkResponse(
                                highlightColor: ThemeColors.primaryBlue,
                                onTap: () async {},
                                child:
                                    SvgPicture.asset('images/search_grey.svg'))
                            : InkResponse(
                                highlightColor: ThemeColors.primaryBlue,
                                onTap: () async {
                                  Navigator.of(context)
                                      .pushNamed(HotelBookmarkPage.routeName);
                                },
                                child: SvgPicture.asset(
                                    'images/bookmark_full.svg',
                                    color: ThemeColors.primaryBlue),
                              ),
                      );
                    },
                  )
                ],
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              floatingActionButton: HotelListFloatingBottomWidget(),
              body: Consumer<HotelListProvider>(
                builder: (_, provider, __) {
                  return StreamBuilder<searchState>(
                      stream: provider.stream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                                ConnectionState.waiting ||
                            provider.pageRequested <= 1) {
                          return Center(child: CircularProgressIndicator());
                        } else {
                          return ListView.builder(
                            itemCount: provider.hotelList.length + 1,
                            controller: provider.scrollController,
                            padding: const EdgeInsets.only(bottom: 80.0),
                            itemBuilder: (context, index) {
                              if (snapshot.data == searchState.empty) {
                                return Container();
                              } else if (index < provider.hotelList.length) {
                                if (index == 0) {
                                  return QuickSearchRowWidget();
                                } else {
                                  return InkResponse(
                                      onTap: () => Navigator.of(context)
                                          .pushNamed(
                                              HotelRevampDetailPage.routeName),
                                      child: HotelSingleRowWidget(
                                        hotelDetail: provider.hotelList[index],
                                      ));
                                }
                              } else if (provider.canLoadMore) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else {
                                return Container();
                              }
                            },
                          );
                        }
                      });
                },
              ),
            );
          }),
    );
  }
}
