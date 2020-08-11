import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localin/components/custom_image_radius.dart';
import 'package:localin/components/filled_button_default.dart';
import 'package:localin/presentation/revamp_hotel/hotel_detail_page/hotel_detail_photos_page.dart';
import 'package:localin/presentation/revamp_hotel/hotel_detail_page/provider/hotel_detail_nestedscroll_provider.dart';
import 'package:localin/presentation/revamp_hotel/hotel_detail_page/widgets/hotel_detail_detail_widget.dart';
import 'package:localin/presentation/revamp_hotel/hotel_detail_page/widgets/hotel_detail_facilities_widget.dart';
import 'package:localin/presentation/revamp_hotel/hotel_detail_page/widgets/hotel_detail_overview_widget.dart';
import 'package:localin/presentation/revamp_hotel/hotel_detail_page/widgets/hotel_detail_room_type_pick_page.dart';
import 'package:localin/presentation/shared_widgets/row_location_widget.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class HotelRevampDetailPage extends StatelessWidget {
  static const routeName = 'HotelRevampDetailPage';
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<HotelDetailNestedScrollProvider>(
          create: (_) => HotelDetailNestedScrollProvider(),
        )
      ],
      child: HotelDetailRevampPage(),
    );
  }
}

class HotelDetailRevampPage extends StatefulWidget {
  @override
  _HotelDetailRevampPageState createState() => _HotelDetailRevampPageState();
}

class _HotelDetailRevampPageState extends State<HotelDetailRevampPage>
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

  Widget _wrapScrollTag({int index, Widget child}) {
    return AutoScrollTag(
      key: ValueKey(index),
      controller: _autoScrollController,
      index: index,
      child: child,
      highlightColor: Colors.black.withOpacity(0.1),
    );
  }

  _buildSliverAppbar() {
    final provider = Provider.of<HotelDetailNestedScrollProvider>(context);
    return SliverAppBar(
      automaticallyImplyLeading: false,
      pinned: true,
      expandedHeight: 260.0,
      titleSpacing: 0.0,
      backgroundColor: Colors.white,
      title: Visibility(
        visible: !isExpanded,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'OYO Life 2736 Pondok Klara',
              style: ThemeText.sfMediumHeadline,
            ),
            Text('Bandung, Jawa Barat • 1.5km from your location',
                style: ThemeText.sfMediumCaption)
          ],
        ),
      ),
      actions: <Widget>[
        Visibility(
          visible: !isExpanded,
          child: Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: SvgPicture.asset('images/bookmark_outline.svg',
                width: 14.0, height: 20.0),
          ),
        )
      ],
      leading: Visibility(
        visible: !isExpanded,
        child: InkWell(
          onTap: () {},
          child: Icon(
            Icons.arrow_back,
            color: ThemeColors.black80,
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        background: Stack(
          children: <Widget>[
            CustomImageRadius(
              radius: 0.0,
              height: 300.0,
              imageUrl:
                  'https://images.pexels.com/photos/638700/pexels-photo-638700.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
            ),
            InkWell(
              onTap: () => Navigator.of(context)
                  .pushNamed(HotelDetailPhotosPage.routeName),
              child: Container(
                height: 300.0,
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: ThemeColors.black100.withOpacity(0.5),
                ),
              ),
            ),
            Positioned(
              left: 20.0,
              top: 50.0,
              child: InkWell(
                onTap: () => Navigator.of(context).pop(),
                child: Icon(
                  Icons.arrow_back,
                  color: ThemeColors.black0,
                ),
              ),
            ),
            Positioned(
                right: 20.0,
                top: 50.0,
                child: SvgPicture.asset(
                  'images/bookmark_outline.svg',
                  width: 14.0,
                  height: 20.0,
                  color: ThemeColors.black0,
                ))
          ],
        ),
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(40),
        child: AnimatedOpacity(
          duration: Duration(milliseconds: 500),
          opacity: isExpanded ? 0.0 : 1,
          child: TabBar(
            controller: _tabController,
            indicatorWeight: 3.0,
            labelStyle: ThemeText.sfSemiBoldBody,
            labelColor: ThemeColors.primaryBlue,
            unselectedLabelColor: ThemeColors.black60,
            onTap: (index) async {
              _scrollToIndex(index);
            },
            tabs: List.generate(
              provider.tabList.length,
              (i) {
                return Tab(
                  text: provider.tabList[i],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.black10,
      bottomNavigationBar: Container(
        height: 68.0,
        color: ThemeColors.black0,
        padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Price /room/night start from',
                  style: ThemeText.sfRegularBody
                      .copyWith(color: ThemeColors.black80),
                ),
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: 'Rp 250.000',
                        style: ThemeText.rodinaTitle2
                            .copyWith(color: ThemeColors.orange)),
                    TextSpan(
                        text: '\tInclude Text',
                        style: ThemeText.sfSemiBoldCaption
                            .copyWith(color: ThemeColors.black60)),
                  ]),
                )
              ],
            ),
            FilledButtonDefault(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(HotelDetailRoomTypePickPage.routeName);
              },
              buttonText: 'Select Room',
              textTheme:
                  ThemeText.rodinaTitle3.copyWith(color: ThemeColors.black0),
            ),
          ],
        ),
      ),
      body: CustomScrollView(
        controller: _autoScrollController,
        slivers: <Widget>[
          _buildSliverAppbar(),
          SliverList(
              delegate: SliverChildListDelegate([
            _wrapScrollTag(index: 0, child: HotelDetailOverviewWidget()),
            _wrapScrollTag(index: 1, child: HotelDetailFacilitesWidget()),
            _wrapScrollTag(index: 2, child: RowLocationWidget()),
            _wrapScrollTag(index: 3, child: HotelDetailDetailsWidget()),
          ])),
        ],
      ),
    );
  }
}
