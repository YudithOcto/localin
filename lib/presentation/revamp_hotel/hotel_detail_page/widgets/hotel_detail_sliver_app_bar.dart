import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localin/components/custom_image_radius.dart';
import 'package:localin/components/custom_toast.dart';
import 'package:localin/presentation/revamp_hotel/hotel_detail_page/hotel_detail_photos_page.dart';
import 'package:localin/presentation/revamp_hotel/hotel_detail_page/provider/hotel_detail_api_provider.dart';
import 'package:localin/presentation/revamp_hotel/hotel_detail_page/provider/hotel_detail_nestedscroll_provider.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:localin/utils/constants.dart';
import 'package:provider/provider.dart';

class HotelDetailSliverAppbar extends StatelessWidget {
  final bool isExpanded;
  final TabController tabController;
  final ValueChanged<int> onChanged;

  HotelDetailSliverAppbar(
      {this.isExpanded, this.tabController, this.onChanged});
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HotelDetailNestedScrollProvider>(context);
    final hotelDetail = Provider.of<HotelDetailApiProvider>(context);
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
              '${hotelDetail?.hotelDetailEntity?.hotelName}',
              style: ThemeText.sfMediumHeadline,
            ),
            Text(
                '${hotelDetail?.hotelDetailEntity?.shortAddress} • ${hotelDetail?.hotelDetailEntity?.distance} from your location',
                style: ThemeText.sfMediumCaption)
          ],
        ),
      ),
      actions: <Widget>[
        Visibility(
          visible: !isExpanded,
          child: InkResponse(
            onTap: () async {
              final result = await Provider.of<HotelDetailApiProvider>(context,
                      listen: false)
                  .changeBookmark();
              CustomToast.showCustomBookmarkToast(context, result);
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: SvgPicture.asset(
                  'images/${hotelDetail.hotelDetailEntity.isBookmark ? 'bookmark_full' : 'bookmark_outline'}.svg',
                  color: hotelDetail.hotelDetailEntity.isBookmark
                      ? ThemeColors.primaryBlue
                      : ThemeColors.black80,
                  width: 14.0,
                  height: 20.0),
            ),
          ),
        )
      ],
      leading: Visibility(
        visible: !isExpanded,
        child: InkWell(
          onTap: () => Navigator.of(context).pop(kRefresh),
          child: Icon(
            Icons.arrow_back,
            color: ThemeColors.black80,
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        background: InkResponse(
          onTap: () {
            Navigator.of(context)
                .pushNamed(HotelDetailPhotosPage.routeName, arguments: {
              HotelDetailPhotosPage.hotelDetail: hotelDetail.hotelDetailEntity,
            });
          },
          child: Stack(
            children: <Widget>[
              CarouselSlider(
                options: CarouselOptions(
                  height: 300.0,
                  autoPlay: true,
                  enlargeCenterPage: false,
                  viewportFraction: 1.0,
                ),
                items: List.generate(
                    hotelDetail.hotelDetailEntity.images.length, (index) {
                  return Stack(
                    children: <Widget>[
                      CustomImageRadius(
                          radius: 0.0,
                          height: 300.0,
                          imageUrl:
                              '${hotelDetail?.hotelDetailEntity?.images[index]}'),
                      Container(
                        height: 300.0,
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                          color: ThemeColors.black100.withOpacity(0.5),
                        ),
                      )
                    ],
                  );
                }),
              ),
              Positioned(
                left: 20.0,
                top: 50.0,
                child: InkWell(
                  onTap: () => Navigator.of(context).pop(kRefresh),
                  child: Icon(
                    Icons.arrow_back,
                    color: ThemeColors.black0,
                  ),
                ),
              ),
              Positioned(
                  right: 20.0,
                  top: 50.0,
                  child: InkResponse(
                    onTap: () async {
                      final result = await Provider.of<HotelDetailApiProvider>(
                              context,
                              listen: false)
                          .changeBookmark();
                      CustomToast.showCustomBookmarkToast(context, result);
                    },
                    highlightColor: ThemeColors.primaryBlue,
                    child: SvgPicture.asset(
                      'images/${hotelDetail.hotelDetailEntity.isBookmark ? 'bookmark_full' : 'bookmark_outline'}.svg',
                      width: 14.0,
                      height: 20.0,
                      color: ThemeColors.black0,
                    ),
                  ))
            ],
          ),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(40),
        child: AnimatedOpacity(
          duration: Duration(milliseconds: 500),
          opacity: isExpanded ? 0.0 : 1,
          child: TabBar(
            controller: tabController,
            indicatorWeight: 3.0,
            labelStyle: ThemeText.sfSemiBoldBody,
            labelColor: ThemeColors.primaryBlue,
            unselectedLabelColor: ThemeColors.black60,
            onTap: (index) async {
              onChanged(index);
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
}
