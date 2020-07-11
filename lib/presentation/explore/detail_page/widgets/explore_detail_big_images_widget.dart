import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:localin/components/custom_image_radius.dart';
import 'package:localin/presentation/explore/detail_page/provider/explore_event_detail_provider.dart';
import 'package:localin/presentation/home/widget/stay/gallery_photo_view.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
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
                onTap: () {
                  List<String> list = [
                    provider.eventDetail.eventBanner,
                  ];
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GalleryPhotoView(
                        galleryItems: list,
                        initialIndex: 0,
                        scrollDirection: Axis.horizontal,
                      ),
                    ),
                  );
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
                  child: Icon(
                    Icons.arrow_back,
                    color: ThemeColors.black0,
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
        )
      ],
    );
  }
}
