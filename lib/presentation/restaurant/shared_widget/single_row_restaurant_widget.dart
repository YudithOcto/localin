import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localin/components/custom_image_only_radius.dart';
import 'package:localin/model/restaurant/restaurant_response_model.dart';
import 'package:localin/presentation/restaurant/restaurant_detail_page.dart';
import 'package:localin/presentation/restaurant/shared_widget/restaurant_basic_detail_widget.dart';
import 'package:localin/presentation/restaurant/shared_widget/restaurant_category_widget.dart';
import 'package:localin/presentation/restaurant/shared_widget/restaurant_rating_widget.dart';
import 'package:localin/themes.dart';

class SingleRowRestaurantWidget extends StatelessWidget {
  final RestaurantDetail restaurantDetail;
  SingleRowRestaurantWidget({@required this.restaurantDetail});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: ThemeColors.primaryBlue,
      onTap: () => Navigator.of(context)
          .pushNamed(RestaurantDetailPage.routeName, arguments: {
        RestaurantDetailPage.restaurantId: restaurantDetail.id.toString()
      }),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 11.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: ThemeColors.black0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: <Widget>[
                CustomImageOnlyRadius(
                  height: 188.0,
                  imageUrl: restaurantDetail.photosUrl ?? '',
                  width: double.maxFinite,
                  placeHolderColor: ThemeColors.black60,
                  topLeft: 8.0,
                  topRight: 8.0,
                ),
                Positioned(
                  top: 12.0,
                  right: 12.0,
                  child: SvgPicture.asset(
                      'images/restaurant_bookmark_not_active.svg',
                      width: 34.0,
                      height: 34.0),
                ),
                Positioned(
                  top: 12.0,
                  left: 12.0,
                  child: RestaurantCategoryWidget(
                    title: restaurantDetail.categoryName,
                  ),
                ),
                Positioned(
                  bottom: 15.0,
                  left: 15.0,
                  child: RestaurantRatingWidget(
                    restaurantDetail: restaurantDetail,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Padding(
              padding:
                  const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0),
              child: RestaurantBasicDetailWidget(
                restaurantDetail: restaurantDetail,
              ),
            )
          ],
        ),
      ),
    );
  }
}

extension on String {
  String get parsePhoto {
    if (this == null || this.isEmpty) return '';
    final result = this.split('?');
    print(result);
    return result != null ? result[0] : '';
  }
}
