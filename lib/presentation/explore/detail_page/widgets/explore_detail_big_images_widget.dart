import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:localin/components/custom_dialog.dart';
import 'package:localin/components/custom_image_radius.dart';
import 'package:localin/presentation/explore/detail_page/provider/explore_event_detail_provider.dart';
import 'package:localin/presentation/shared_widgets/gallery_photo_view.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:localin/utils/image_redirect.dart';
import 'package:network_image_to_byte/network_image_to_byte.dart';
import 'package:provider/provider.dart';

class ExploreDetailBigImagesWidget extends StatefulWidget {
  @override
  _ExploreDetailBigImagesWidgetState createState() =>
      _ExploreDetailBigImagesWidgetState();
}

class _ExploreDetailBigImagesWidgetState
    extends State<ExploreDetailBigImagesWidget> {
  int _current = 0;
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ExploreEventDetailProvider>(context);
    return Stack(
      children: <Widget>[
        Container(
          width: double.maxFinite,
          height: 260.0,
          child: CarouselSlider(
            options: CarouselOptions(
                aspectRatio: 1.5,
                height: 260,
                autoPlay: false,
                enableInfiniteScroll: false,
                enlargeCenterPage: false,
                viewportFraction: 1.0,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                }),
            items: List.generate(1, (index) {
              return InkWell(
                onTap: () async {
                  List<String> items = [provider.eventDetail.eventBanner];
                  redirectImage(context, items);
                },
                child: CustomImageRadius(
                  height: 260.0,
                  width: double.maxFinite,
                  imageUrl: provider.eventDetail.eventBanner,
                ),
              );
            }),
          ),
        ),
        Container(
          height: 260.0,
          width: double.maxFinite,
          color: ThemeColors.black100.withOpacity(0.5),
        ),
        Positioned(
          bottom: 12.0,
          left: 0.0,
          right: 0.0,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                  1,
                  (carouselIndex) => Container(
                        width: 8.0,
                        height: 8.0,
                        margin: EdgeInsets.only(
                            left: carouselIndex == 0 ? 0.0 : 8.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: carouselIndex == _current
                              ? Colors.white
                              : Colors.white.withOpacity(0.6),
                        ),
                      ))),
        ),
        Positioned(
          top: 24.0,
          left: 16.0,
          child: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: ThemeColors.black80,
                          offset: Offset(0, 0),
                          blurRadius: 15,
                          spreadRadius: 0.2,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.arrow_back,
                      color: ThemeColors.black0,
                    ),
                  ),
                ),
                SizedBox(width: 16.0),
                Text(
                  'Back',
                  style: ThemeText.sfMediumHeadline
                      .copyWith(color: ThemeColors.black0),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
