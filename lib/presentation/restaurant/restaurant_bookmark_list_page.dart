import 'package:flutter/material.dart';
import 'package:localin/components/custom_app_bar.dart';
import 'package:localin/components/custom_toast.dart';
import 'package:localin/presentation/restaurant/provider/restaurant_bookmark_list_provider.dart';
import 'package:localin/presentation/restaurant/shared_widget/empty_restaurant_widget.dart';
import 'package:localin/presentation/restaurant/shared_widget/single_row_restaurant_widget.dart';
import 'package:localin/presentation/search/provider/search_event_provider.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

class RestaurantBookmarkListPage extends StatelessWidget {
  static const routeName = 'RestaurantBookmarkListPage';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RestaurantBookmarkListProvider>(
      create: (_) => RestaurantBookmarkListProvider(),
      child: LayoutBuilder(
        builder: (context, constraint) {
          return Scaffold(
            backgroundColor: ThemeColors.black10,
            appBar: CustomAppBar(
              appBar: AppBar(),
              pageTitle: 'Restaurant Bookmarked',
              leadingIcon: InkResponse(
                onTap: () {
                  if (Provider.of<RestaurantBookmarkListProvider>(context)
                      .trackChangedVariable) {
                    Navigator.of(context).pop(true);
                  } else {
                    Navigator.of(context).pop();
                  }
                },
                child: Icon(Icons.arrow_back, color: ThemeColors.black80),
              ),
            ),
            body: RestaurantBookmarkListBuilder(),
          );
        },
      ),
    );
  }
}

class RestaurantBookmarkListBuilder extends StatefulWidget {
  @override
  _RestaurantBookmarkListBuilderState createState() =>
      _RestaurantBookmarkListBuilderState();
}

class _RestaurantBookmarkListBuilderState
    extends State<RestaurantBookmarkListBuilder> {
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      Provider.of<RestaurantBookmarkListProvider>(context, listen: false)
          .getBookmarkRestaurantList();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<searchState>(
        stream:
            Provider.of<RestaurantBookmarkListProvider>(context, listen: false)
                .stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              Provider.of<RestaurantBookmarkListProvider>(context)
                      .pageRequest <=
                  1) {
            return Center(child: CircularProgressIndicator());
          } else {
            final restaurantList =
                Provider.of<RestaurantBookmarkListProvider>(context)
                    .restaurantList;
            return WillPopScope(
              onWillPop: () async {
                if (Provider.of<RestaurantBookmarkListProvider>(context)
                    .trackChangedVariable) {
                  Navigator.of(context).pop(true);
                } else {
                  Navigator.of(context).pop();
                }
                return false;
              },
              child: ListView.builder(
                itemCount: restaurantList.length + 1,
                itemBuilder: (context, index) {
                  if (snapshot.data == searchState.empty) {
                    return EmptyRestaurantWidget(
                      title: 'You don\'t have any bookmarked restaurants',
                      subtitle: 'Lets explore more restaurants around',
                    );
                  } else if (index < restaurantList.length) {
                    return SingleRowRestaurantWidget(
                      restaurantDetail: restaurantList[index],
                      onValueChanged: (v) {
                        if (v != null) {
                          Provider.of<RestaurantBookmarkListProvider>(context,
                                  listen: false)
                              .getBookmarkRestaurantList();
                        }
                      },
                      onTap: () async {
                        final message =
                            await Provider.of<RestaurantBookmarkListProvider>(
                                    context,
                                    listen: false)
                                .unBookMarkRestaurant(index);
                        CustomToast.showCustomBookmarkToast(context, message);
                      },
                    );
                  } else if (Provider.of<RestaurantBookmarkListProvider>(
                          context)
                      .canLoadMore) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            );
          }
        });
  }
}
