import 'package:flutter/material.dart';
import 'package:localin/presentation/revamp_hotel/hotel_detail_page/provider/hotel_detail_api_provider.dart';
import 'package:localin/presentation/revamp_hotel/hotel_detail_page/widgets/hotel_detail_sliver_app_bar.dart';
import 'package:localin/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:localin/presentation/revamp_hotel/hotel_detail_page/widgets/hotel_detail_bottom_widget.dart';
import 'package:localin/presentation/revamp_hotel/hotel_detail_page/widgets/hotel_detail_detail_widget.dart';
import 'package:localin/presentation/revamp_hotel/hotel_detail_page/widgets/hotel_detail_facilities_widget.dart';
import 'package:localin/presentation/revamp_hotel/hotel_detail_page/widgets/hotel_detail_overview_widget.dart';
import 'package:localin/presentation/revamp_hotel/hotel_detail_page/widgets/wrap_to_scroll_tag_widget.dart';
import 'package:localin/presentation/search/provider/generic_provider.dart';
import 'package:localin/presentation/shared_widgets/row_location_widget.dart';
import 'package:localin/themes.dart';

class HotelDetailRevampBuilder extends StatefulWidget {
  @override
  _HotelDetailRevampBuilderState createState() =>
      _HotelDetailRevampBuilderState();
}

class _HotelDetailRevampBuilderState extends State<HotelDetailRevampBuilder>
    with SingleTickerProviderStateMixin {
  AutoScrollController _autoScrollController;
  final scrollDirection = Axis.vertical;
  TabController _tabController;

  bool isExpanded = true;
  bool get _isAppBarExpanded {
    return _autoScrollController.hasClients &&
        _autoScrollController.offset > (160 - kToolbarHeight);
  }

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    _autoScrollController = AutoScrollController(
      viewportBoundaryGetter: () =>
          Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
      axis: scrollDirection,
    )..addListener(
        () {
          if (_autoScrollController.offset >=
              _autoScrollController.position.maxScrollExtent) {
            _tabController.index = 3;
          } else if (_autoScrollController.offset >
              _autoScrollController.position.maxScrollExtent * 0.7) {
            _tabController.index = 2;
          } else if (_autoScrollController.offset >=
              _autoScrollController.position.maxScrollExtent * 0.3) {
            _tabController.index = 1;
          } else {
            _tabController.index = 0;
          }
          _isAppBarExpanded
              ? isExpanded != false
                  ? setState(
                      () {
                        isExpanded = false;
                      },
                    )
                  : {}
              : isExpanded != true
                  ? setState(() {
                      isExpanded = true;
                    })
                  : {};
        },
      );
    super.initState();
  }

  Future _scrollToIndex(int index) async {
    await _autoScrollController.scrollToIndex(index,
        preferPosition: AutoScrollPosition.begin);
    _autoScrollController.highlight(index);
  }

  onBackPressed() {
    Navigator.of(context).pop(kRefresh);
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
        bottomNavigationBar: HotelDetailBottomWidget(),
        body: StreamBuilder<searchState>(
            stream: Provider.of<HotelDetailApiProvider>(context, listen: false)
                .stream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else {
                final detail = Provider.of<HotelDetailApiProvider>(context)
                    .hotelDetailEntity;
                return CustomScrollView(
                  controller: _autoScrollController,
                  slivers: <Widget>[
                    HotelDetailSliverAppbar(
                      isExpanded: isExpanded,
                      tabController: _tabController,
                      onChanged: (index) {
                        _scrollToIndex(index);
                      },
                    ),
                    SliverList(
                        delegate: SliverChildListDelegate([
                      WrapToScrollTagWidget(
                        index: 0,
                        child: HotelDetailOverviewWidget(),
                        autoScrollController: _autoScrollController,
                      ),
                      WrapToScrollTagWidget(
                        index: 1,
                        child: HotelDetailFacilitiesWidget(),
                        autoScrollController: _autoScrollController,
                      ),
                      WrapToScrollTagWidget(
                          index: 2,
                          autoScrollController: _autoScrollController,
                          child: RowLocationWidget(
                            latitude: detail.latitude,
                            longitude: detail.longitude,
                            eventAddress: detail.shortAddress,
                            eventName: detail.hotelName,
                          )),
                      WrapToScrollTagWidget(
                        index: 3,
                        child: HotelDetailDetailsWidget(),
                        autoScrollController: _autoScrollController,
                      ),
                    ])),
                  ],
                );
              }
            }),
      ),
    );
  }
}
