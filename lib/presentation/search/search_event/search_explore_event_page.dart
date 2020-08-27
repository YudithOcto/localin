import 'package:flutter/material.dart';
import 'package:localin/components/custom_image_radius.dart';
import 'package:localin/model/explore/base_event_request_model.dart';
import 'package:localin/model/explore/explore_event_local_model.dart';
import 'package:localin/model/explore/explore_event_response_model.dart';
import 'package:localin/model/explore/explore_suggest_nearby.dart';
import 'package:localin/model/explore/explore_title.dart';
import 'package:localin/model/explore/explorer_event_category_detail.dart';
import 'package:localin/presentation/explore/detail_page/explore_detail_page.dart';
import 'package:localin/presentation/restaurant/shared_widget/location_near_me_widget.dart';
import 'package:localin/presentation/search/provider/search_event_provider.dart';
import 'package:localin/presentation/shared_widgets/subtitle.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:localin/utils/constants.dart';
import 'package:localin/utils/debounce.dart';
import 'package:provider/provider.dart';

import 'empty_event.dart';
import 'explore_location_widget.dart';

class SearchExploreEventPage extends StatelessWidget {
  static const routeName = 'SearchExplorePage';
  static const typePage = 'TypePage';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SearchEventProvider>(
      create: (_) => SearchEventProvider(),
      child: SearchExploreContentWidget(),
    );
  }
}

class SearchExploreContentWidget extends StatefulWidget {
  @override
  _SearchExploreContentWidgetState createState() =>
      _SearchExploreContentWidgetState();
}

class _SearchExploreContentWidgetState
    extends State<SearchExploreContentWidget> {
  final _scrollController = ScrollController();
  bool _isInit = true;
  final _debounce = Debounce(milliseconds: 400);
  String _pageType = '';

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _scrollController.addListener(_listen);
      Provider.of<SearchEventProvider>(context, listen: false)
          .loadSearchData(type: _pageType);
      final routeArgs =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      _pageType = routeArgs[SearchExploreEventPage.typePage];
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  _listen() {
    if (_scrollController.offset >=
        _scrollController.position.maxScrollExtent) {
      Provider.of<SearchEventProvider>(context, listen: false)
          .loadSearchData(type: _pageType, isRefresh: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ThemeColors.black0,
        titleSpacing: 0.0,
        leading: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: Icon(
            Icons.arrow_back,
            color: ThemeColors.black80,
          ),
        ),
        title: Container(
          height: 43.0,
          margin: EdgeInsets.only(right: 20.0),
          child: TextFormField(
            controller: Provider.of<SearchEventProvider>(context, listen: false)
                .searchController,
            autofocus: true,
            onChanged: (v) {
              _debounce.run(() => Provider.of<SearchEventProvider>(context,
                      listen: false)
                  .loadSearchData(type: _pageType, isRefresh: true, search: v));
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: ThemeColors.black10,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6.0),
                  borderSide: BorderSide(color: ThemeColors.black0)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6.0),
                  borderSide: BorderSide(color: ThemeColors.black0)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6.0),
                  borderSide: BorderSide(color: ThemeColors.black0)),
              hintText: 'Search $_pageType',
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
              hintStyle:
                  ThemeText.sfRegularBody.copyWith(color: ThemeColors.black60),
            ),
          ),
        ),
      ),
      body: Consumer<SearchEventProvider>(
        builder: (context, provider, child) {
          return RefreshIndicator(
            onRefresh: () async {
              Provider.of<SearchEventProvider>(context, listen: false)
                  .loadSearchData(isRefresh: true, type: _pageType);
            },
            child: StreamBuilder<searchState>(
                stream: provider.searchStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting &&
                      provider.offset <= 1) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: provider.searchList.length + 1,
                      itemBuilder: (context, index) {
                        if (snapshot.data == searchState.empty) {
                          return emptyState();
                        } else if (index < provider.searchList.length) {
                          return successfulWidget(provider.searchList[index]);
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
                }),
          );
        },
      ),
    );
  }

  Widget successfulWidget(BaseEventRequestmodel data) {
    Map<String, dynamic> navigateBackMap = Map();
    if (data is ExploreTitle) {
      return Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0),
        child: Subtitle(
          title: data.title,
        ),
      );
    } else if (data is ExploreSearchLocation) {
      return ExploreLocationWidget(
        title: data.districtName,
        subtitle: 'City',
        category: '${data.total} event(s)',
        onTap: () {
          Provider.of<SearchEventProvider>(context, listen: false)
              .addToSearchLocal(ExploreEventLocalModel(
            title: data.districtName,
            subtitle: 'City',
            category: '${data.total} event(s)',
            timeStamp: DateTime.now().toIso8601String(),
          ));
          navigateBackMap[kLocationMap] = data.districtName;
          Navigator.of(context).pop(navigateBackMap);
        },
      );
    } else if (data is ExploreEventDetail) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
        child: InkWell(
          onTap: () {
            Navigator.of(context)
                .pushNamed(ExploreDetailPage.routeName, arguments: {
              ExploreDetailPage.exploreId: data.idEvent,
            });
          },
          child: Row(
            children: <Widget>[
              CustomImageRadius(
                radius: 8.0,
                imageUrl: data.eventBanner,
                width: 48.0,
                height: 48.0,
              ),
              SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(data?.eventName, style: ThemeText.rodinaHeadline),
                    Text(
                      '${data?.location?.address}',
                      maxLines: 2,
                      style: ThemeText.sfMediumFootnote
                          .copyWith(color: ThemeColors.black80),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      );
    } else if (data is ExploreSuggestNearby) {
      return LocationNearMeWidget(
        title: data.title,
      );
    } else if (data is ExploreEventLocalModel) {
      return ExploreLocationWidget(
        title: data.title,
        subtitle: data.subtitle,
        category: '${data.category}',
        onTap: () {
          Provider.of<SearchEventProvider>(context, listen: false)
              .addToSearchLocal(ExploreEventLocalModel(
            title: data.title,
            subtitle: 'City',
            category: '${data.category}',
            timeStamp: DateTime.now().toIso8601String(),
          ));
          navigateBackMap[kLocationMap] = data.title;
          Navigator.of(context).pop(navigateBackMap);
        },
      );
    } else if (data is ExploreEventCategoryDetail) {
      return ExploreLocationWidget(
        title: data.categoryName,
        subtitle: '',
        category: '${data.total} event(s)',
        onTap: () {
          Provider.of<SearchEventProvider>(context, listen: false)
              .addToSearchLocal(ExploreEventLocalModel(
            title: data.categoryName,
            subtitle: 'City',
            category: '${data.total} event(s)',
            timeStamp: DateTime.now().toIso8601String(),
          ));
          navigateBackMap[kCategoryMap] = data;
          Navigator.of(context).pop(navigateBackMap);
        },
      );
    } else {
      return Container();
    }
  }

  Widget emptyState() {
    return EmptyExploreEvent();
  }
}
