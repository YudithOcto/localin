import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localin/components/custom_toast.dart';
import 'package:localin/presentation/restaurant/provider/restaurant_provider.dart';
import 'package:localin/presentation/restaurant/restaurant_bookmark_list_page.dart';
import 'package:localin/presentation/restaurant/search_restaurant_page.dart';
import 'package:localin/presentation/restaurant/shared_widget/bottom_sort_restaurant_widget.dart';
import 'package:localin/presentation/restaurant/shared_widget/empty_restaurant_widget.dart';
import 'package:localin/presentation/restaurant/shared_widget/single_row_restaurant_widget.dart';
import 'package:localin/presentation/search/provider/search_event_provider.dart';
import 'package:localin/presentation/shared_widgets/borderless_search_widget.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:localin/utils/constants.dart';
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
              title: Consumer<RestaurantProvider>(
                builder: (_, provider, __) {
                  return Text(
                    'Eats ${!provider.isShowSearchAppBar ? provider.searchController.text : ''}',
                    style: ThemeText.sfMediumHeadline,
                  );
                },
              ),
              titleSpacing: 0.0,
              leading: InkWell(
                onTap: () => Navigator.of(context).pop(),
                child: Icon(Icons.arrow_back, color: ThemeColors.black80),
              ),
              actions: <Widget>[
                Consumer<RestaurantProvider>(
                  builder: (_, provider, __) {
                    print(provider.isShowSearchAppBar);
                    return Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: provider.isShowSearchAppBar
                          ? InkResponse(
                              highlightColor: ThemeColors.primaryBlue,
                              onTap: () async {
                                final result = await Navigator.of(context)
                                    .pushNamed(
                                        RestaurantBookmarkListPage.routeName);
                                if (result != null) {
                                  provider.getRestaurantList(isRefresh: true);
                                }
                              },
                              child: SvgPicture.asset(
                                  'images/bookmark_full.svg',
                                  color: ThemeColors.primaryBlue),
                            )
                          : InkResponse(
                              highlightColor: ThemeColors.primaryBlue,
                              onTap: () async {
                                final result = await Navigator.of(context)
                                    .pushNamed(SearchRestaurantPage.routeName);
                                if (result != null) {
                                  provider.searchController.text = result;
                                  provider.scrollController.jumpTo(0.0);
                                  provider.showSearchAppBar = false;
                                  if (result == kNearby) {
                                    provider.getRestaurantList(
                                        isRefresh: true,
                                        isLocation: 1,
                                        sort: 'jarak',
                                        order: 'asc');
                                  } else {
                                    provider.getRestaurantList(
                                        isRefresh: true, search: result);
                                  }
                                }
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
                                  return buildEmptyState(index, provider);
                                } else if (index <
                                    provider.restaurantList.length + 2) {
                                  return buildContentState(index, provider);
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
                      return BottomSortRestaurantWidget(
                        currentSelectedIndex: provider.currentSelectedIndex,
                        onPressed: (v) {
                          Navigator.of(context).pop();
                          provider.getRestaurantListWithSorting(v);
                        },
                      );
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

  Widget buildContentState(int index, RestaurantProvider provider) {
    if (index == 0) {
      return InkResponse(
        onTap: () async {
          final result = await Navigator.of(context)
              .pushNamed(SearchRestaurantPage.routeName);
          if (result != null) {
            provider.searchController.text = result;
            provider.scrollController.jumpTo(0.0);
            provider.showSearchAppBar = false;
            if (result == kNearby) {
              provider.getRestaurantList(
                  isRefresh: true, sort: 'jarak', order: 'asc', isLocation: 1);
            } else {
              provider.getRestaurantList(
                  isRefresh: true, search: result, isLocation: 1);
            }
          }
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20.0),
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: BorderlessSearchWidget(
            backgroundColor: ThemeColors.black0,
            isShowPrefixIcon: true,
            isAutoFocus: false,
            isEnabled: false,
            controller: provider.searchController,
            title: kNearby,
          ),
        ),
      );
    } else {
      if (index == 1) {
        return Padding(
          padding: const EdgeInsets.only(top: 21.0, left: 20.0, right: 20.0),
          child: Text('${provider.restaurantTotal} Restaurant found',
              style: ThemeText.rodinaHeadline),
        );
      } else {
        return SingleRowRestaurantWidget(
          onTap: () async {
            final result = await provider.updateBookmarkRestaurant(index - 2);
            CustomToast.showCustomBookmarkToast(context, result);
          },
          onValueChanged: (value) {
            if (value != null) {
              provider.scrollController.jumpTo(0.0);
              provider.showSearchAppBar = true;
              provider.getRestaurantList();
            }
          },
          restaurantDetail: provider.restaurantList[index - 2],
        );
      }
    }
  }

  Widget buildEmptyState(int index, RestaurantProvider provider) {
    if (index == 1) {
      return Padding(
        padding: const EdgeInsets.only(top: 21.0, left: 20.0, right: 20.0),
        child: Text('Restaurants not found', style: ThemeText.rodinaHeadline),
      );
    } else if (index == 2) {
      return EmptyRestaurantWidget(
        onPressed: () async {
          final result = await Navigator.of(context)
              .pushNamed(SearchRestaurantPage.routeName);
          if (result != null) {
            provider.searchController.text = result;
            provider.scrollController.jumpTo(0.0);
            provider.showSearchAppBar = false;
            if (result == kNearby) {
              provider.getRestaurantList(
                  isRefresh: true, sort: 'jarak', order: 'asc');
            } else {
              provider.getRestaurantList(isRefresh: true, search: result);
            }
          }
        },
      );
    } else if (index == 0) {
      return InkWell(
        onTap: () async {
          final result = await Navigator.of(context)
              .pushNamed(SearchRestaurantPage.routeName);
          if (result != null) {
            provider.searchController.text = result;
            provider.scrollController.jumpTo(0.0);
            provider.showSearchAppBar = true;
            if (result == kNearby) {
              provider.getRestaurantList(
                  isRefresh: true, sort: 'jarak', order: 'asc');
            } else {
              provider.getRestaurantList(isRefresh: true, search: result);
            }
          }
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20.0),
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: BorderlessSearchWidget(
            backgroundColor: ThemeColors.black0,
            isShowPrefixIcon: true,
            isEnabled: false,
            isAutoFocus: false,
            controller: provider.searchController,
            title: kNearby,
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}
