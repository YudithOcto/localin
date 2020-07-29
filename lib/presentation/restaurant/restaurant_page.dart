import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localin/presentation/restaurant/provider/restaurant_provider.dart';
import 'package:localin/presentation/restaurant/restaurant_bookmark_list_page.dart';
import 'package:localin/presentation/restaurant/search_restaurant_page.dart';
import 'package:localin/presentation/restaurant/shared_widget/bottom_sort_restaurant_widget.dart';
import 'package:localin/presentation/restaurant/shared_widget/empty_restaurant_widget.dart';
import 'package:localin/presentation/restaurant/shared_widget/single_row_restaurant_widget.dart';
import 'package:localin/presentation/search/provider/generic_provider.dart';
import 'package:localin/presentation/shared_widgets/borderless_search_widget.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

class RestaurantPage extends StatefulWidget {
  static const routeName = 'RestaurantPage';
  @override
  _RestaurantPageState createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RestaurantProvider>(
      create: (_) => RestaurantProvider(),
      child: LayoutBuilder(
        builder: (context, boxConstraints) {
          return Scaffold(
            backgroundColor: ThemeColors.black10,
            appBar: AppBar(
              backgroundColor: ThemeColors.black0,
              title: Text(
                'Eats',
                style: ThemeText.sfMediumHeadline,
              ),
              titleSpacing: 0.0,
              leading: InkWell(
                onTap: () {},
                child: Icon(Icons.arrow_back, color: ThemeColors.black80),
              ),
              actions: <Widget>[
                Consumer<RestaurantProvider>(
                  builder: (_, provider, __) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: provider.isShowSearchAppBar
                          ? InkResponse(
                              highlightColor: ThemeColors.primaryBlue,
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                    RestaurantBookmarkListPage.routeName);
                              },
                              child: SvgPicture.asset(
                                  'images/bookmark_full.svg',
                                  color: ThemeColors.primaryBlue),
                            )
                          : InkResponse(
                              highlightColor: ThemeColors.primaryBlue,
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed(SearchRestaurantPage.routeName);
                              },
                              child:
                                  SvgPicture.asset('images/search_grey.svg')),
                    );
                  },
                )
              ],
            ),
            body: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Consumer<RestaurantProvider>(
                  builder: (_, provider, __) {
                    return StreamBuilder<searchState>(
                        stream: provider.stream,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                                  ConnectionState.waiting &&
                              provider.pageRequest <= 1) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            return ListView.builder(
                              shrinkWrap: true,
                              controller: provider.scrollController,
                              padding: const EdgeInsets.only(bottom: 80.0),
                              physics: ClampingScrollPhysics(),
                              itemCount: provider.restaurantList.length + 3,
                              itemBuilder: (context, index) {
                                if (snapshot.data == searchState.empty) {
                                  if (index == 1) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          top: 21.0, left: 20.0, right: 20.0),
                                      child: Text('Restaurants not found',
                                          style: ThemeText.rodinaHeadline),
                                    );
                                  } else if (index == 2) {
                                    return EmptyRestaurantWidget();
                                  } else if (index == 0) {
                                    return Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16.0),
                                      child: BorderlessSearchWidget(
                                        backgroundColor: ThemeColors.black0,
                                        isShowPrefixIcon: true,
                                        isAutoFocus: false,
                                        controller: provider.searchController,
                                        onChanged: (v) {
                                          provider.getRestaurantList(
                                              isRefresh: true, search: v);
                                        },
                                        title: 'Search Restaurant',
                                      ),
                                    );
                                  } else {
                                    return Container();
                                  }
                                } else if (index <
                                    provider.restaurantList.length + 2) {
                                  if (index == 0) {
                                    return Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16.0),
                                      child: BorderlessSearchWidget(
                                        backgroundColor: ThemeColors.black0,
                                        isShowPrefixIcon: true,
                                        isAutoFocus: false,
                                        controller: provider.searchController,
                                        onChanged: (v) {
                                          provider.getRestaurantList(
                                              isRefresh: true, search: v);
                                        },
                                        title: 'Search Restaurant',
                                      ),
                                    );
                                  } else {
                                    if (index == 1) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                            top: 21.0, left: 20.0, right: 20.0),
                                        child: Text(
                                            '${provider.restaurantTotal} Restaurant found',
                                            style: ThemeText.rodinaHeadline),
                                      );
                                    } else {
                                      return SingleRowRestaurantWidget(
                                        restaurantDetail:
                                            provider.restaurantList[index - 2],
                                      );
                                    }
                                  }
                                } else if (provider.canLoadMore) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            );
                          }
                        });
                  },
                ),
                Positioned(
                  bottom: 20.0,
                  child: Consumer<RestaurantProvider>(
                    builder: (_, provider, __) {
                      return Visibility(
                          visible: provider.restaurantTotal > 0,
                          child: BottomSortRestaurantWidget(
                            currentSelectedIndex: provider.currentSelectedIndex,
                            onPressed: (v) {
                              Navigator.of(context).pop();
                              provider.getRestaurantListWithSorting(v);
                            },
                          ));
                    },
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
