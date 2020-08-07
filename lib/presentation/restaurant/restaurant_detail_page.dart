import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localin/components/custom_image_radius.dart';
import 'package:localin/components/custom_toast.dart';
import 'package:localin/model/restaurant/restaurant_response_model.dart';
import 'package:localin/presentation/community/community_event/provider/community_event_provider.dart';
import 'package:localin/presentation/restaurant/provider/restaurant_detail_provider.dart';
import 'package:localin/presentation/restaurant/shared_widget/restaurant_basic_detail_widget.dart';
import 'package:localin/presentation/shared_widgets/row_category_widget.dart';
import 'package:localin/presentation/shared_widgets/custom_rating_widget.dart';
import 'package:localin/presentation/shared_widgets/row_location_widget.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

class RestaurantDetailPage extends StatelessWidget {
  static const routeName = 'RestaurantDetailPage';
  static const restaurantLocalModel = 'RestaurantLocalModel';
  static const restaurantId = 'RestaurantID';

  @override
  Widget build(BuildContext context) {
    final routes =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    return ChangeNotifierProvider<RestaurantDetailProvider>(
      create: (_) => RestaurantDetailProvider(routes[restaurantLocalModel]),
      child: RestaurantDetailBuilderWidget(),
    );
  }
}

class RestaurantDetailBuilderWidget extends StatefulWidget {
  @override
  _RestaurantDetailBuilderWidgetState createState() =>
      _RestaurantDetailBuilderWidgetState();
}

class _RestaurantDetailBuilderWidgetState
    extends State<RestaurantDetailBuilderWidget> {
  bool _isInit = true;
  @override
  void didChangeDependencies() {
    if (_isInit) {
      final routes =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      if (routes != null && routes[RestaurantDetailPage.restaurantId] != null) {
        loadRestaurantData(routes[RestaurantDetailPage.restaurantId]);
      }
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  loadRestaurantData(String restaurantId) {
    Provider.of<RestaurantDetailProvider>(context, listen: false)
        .getRestaurantDetail(restaurantId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.black10,
      body: StreamBuilder<eventState>(
          stream: Provider.of<RestaurantDetailProvider>(context, listen: false)
              .stream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting ||
                (snapshot.hasData && snapshot.data == eventState.loading)) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              final restaurantDetail =
                  Provider.of<RestaurantDetailProvider>(context)
                      .restaurantDetail as RestaurantDetail;
              return WillPopScope(
                onWillPop: () async {
                  Navigator.of(context).pop(true);
                  return false;
                },
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          CustomImageRadius(
                            radius: 0.0,
                            height: 260.0,
                            width: double.maxFinite,
                            imageUrl: restaurantDetail?.photosUrl ?? '',
                            placeHolderColor: ThemeColors.black80,
                          ),
                          Container(
                            height: 260.0,
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                              color: ThemeColors.black100.withOpacity(0.5),
                            ),
                          ),
                          Positioned(
                            left: 20.0,
                            top: 20.0,
                            child: SafeArea(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop(true);
                                },
                                child: Icon(Icons.arrow_back,
                                    color: ThemeColors.black0),
                              ),
                            ),
                          ),
                          Positioned(
                            right: 20.0,
                            top: 20.0,
                            child: SafeArea(
                              child: GestureDetector(
                                onTap: () async {
                                  final result = await Provider.of<
                                              RestaurantDetailProvider>(context,
                                          listen: false)
                                      .updateBookmarkRestaurant();
                                  CustomToast.showCustomBookmarkToast(
                                      context, result,
                                      duration: 1);
                                },
                                child: SvgPicture.asset(
                                    'images/${restaurantDetail.isBookMark ? 'restaurant_bookmark_active' : 'restaurant_bookmark_not_active'}.svg',
                                    width: 34.0,
                                    height: 34.0),
                              ),
                            ),
                          )
                        ],
                      ),
                      Container(
                        color: ThemeColors.black0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 20.0, horizontal: 20.0),
                              child: Row(
                                children: <Widget>[
                                  RowCategoryWidget(
                                    title: restaurantDetail?.categoryName,
                                  ),
                                  SizedBox(width: 12.0),
                                  CustomRatingWidget(
                                    starRating: restaurantDetail?.userRating,
                                    totalRating:
                                        restaurantDetail?.userRatingVotes,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 13.0),
                              child: RestaurantBasicDetailWidget(
                                restaurantDetail: restaurantDetail,
                              ),
                            ),
                          ],
                        ),
                      ),
                      RowLocationWidget(
                        eventName: restaurantDetail.name,
                        eventAddress: restaurantDetail.address,
                        latitude: restaurantDetail.latitude,
                        longitude: restaurantDetail.longitude,
                      )
                      // RowLocationWidget(),
                    ],
                  ),
                ),
              );
            }
          }),
    );
  }
}
