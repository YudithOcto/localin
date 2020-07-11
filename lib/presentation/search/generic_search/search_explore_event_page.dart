import 'package:flutter/material.dart';
import 'package:localin/components/custom_image_radius.dart';
import 'package:localin/model/explore/explore_event_response_model.dart';
import 'package:localin/model/location/search_location_response.dart';
import 'package:localin/presentation/error_page/empty_page.dart';
import 'package:localin/presentation/search/provider/generic_provider.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:localin/utils/debounce.dart';
import 'package:provider/provider.dart';

import 'empty_event.dart';

class SearchExploreEventPage extends StatelessWidget {
  static const routeName = 'SearchExplorePage';
  static const typePage = 'TypePage';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GenericProvider>(
      create: (_) => GenericProvider(),
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
      Provider.of<GenericProvider>(context, listen: false)
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
      Provider.of<GenericProvider>(context, listen: false)
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
            controller: Provider.of<GenericProvider>(context, listen: false)
                .searchController,
            onChanged: (v) {
              _debounce.run(() => Provider.of<GenericProvider>(context,
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
      body: Consumer<GenericProvider>(
        builder: (context, provider, child) {
          return RefreshIndicator(
            onRefresh: () async {
              Provider.of<GenericProvider>(context, listen: false)
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

  Widget successfulWidget(dynamic data) {
    if (data is LocationResponseDetail) {
      return Container();
    } else if (data is ExploreEventDetail) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
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
                    data?.schedule[0]?.address,
                    maxLines: 2,
                    style: ThemeText.sfMediumFootnote
                        .copyWith(color: ThemeColors.black80),
                  )
                ],
              ),
            )
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  Widget emptyState() {
    switch (_pageType) {
      case TYPE_LOCATION:
        return EmptyPage();
        break;
      case TYPE_EVENT:
        return EmptyExploreEvent();
        break;
    }
    return Container();
  }
}
