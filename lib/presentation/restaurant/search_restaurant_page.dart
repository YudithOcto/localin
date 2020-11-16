import 'package:flutter/material.dart';
import 'package:localin/model/restaurant/restaurant_local_model.dart';
import 'package:localin/model/restaurant/restaurant_response_model.dart';
import 'package:localin/model/restaurant/restaurant_search_base_model.dart';
import 'package:localin/model/restaurant/restaurant_search_title.dart';
import 'package:localin/presentation/restaurant/provider/search_restaurant_provider.dart';
import 'package:localin/presentation/restaurant/restaurant_detail_page.dart';
import 'package:localin/presentation/restaurant/shared_widget/empty_restaurant_widget.dart';
import 'package:localin/presentation/restaurant/shared_widget/location_near_me_widget.dart';
import 'package:localin/presentation/shared_widgets/subtitle.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:localin/utils/debounce.dart';
import 'package:provider/provider.dart';

class SearchRestaurantPage extends StatelessWidget {
  static const routeName = 'SearchRestaurantPage';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SearchRestaurantProvider>(
      create: (_) => SearchRestaurantProvider(),
      child: SearchRestaurantBuilder(),
    );
  }
}

class SearchRestaurantBuilder extends StatefulWidget {
  @override
  _SearchRestaurantBuilderState createState() =>
      _SearchRestaurantBuilderState();
}

class _SearchRestaurantBuilderState extends State<SearchRestaurantBuilder> {
  bool _isInit = true;
  Debounce _debounce;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _debounce = Debounce(milliseconds: 500);
      loadData();
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  loadData() {
    Provider.of<SearchRestaurantProvider>(context, listen: false)
        .getRestaurantList();
  }

  @override
  void dispose() {
    _debounce.cancel();
    super.dispose();
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
            controller:
                Provider.of<SearchRestaurantProvider>(context, listen: false)
                    .searchController,
            onChanged: (v) {
              _debounce.run(() =>
                  Provider.of<SearchRestaurantProvider>(context, listen: false)
                      .getRestaurantList(search: v));
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
              hintText: 'Search for City or Restaurant',
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
              hintStyle:
                  ThemeText.sfRegularBody.copyWith(color: ThemeColors.black60),
            ),
          ),
        ),
      ),
      body: StreamBuilder<searchRestaurantEvent>(
          stream: Provider.of<SearchRestaurantProvider>(context, listen: false)
              .stream,
          builder: (context, snapshot) {
            print(snapshot);
            if (snapshot.connectionState == ConnectionState.waiting ||
                snapshot.hasData &&
                    snapshot.data == searchRestaurantEvent.loading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              final searchResult =
                  Provider.of<SearchRestaurantProvider>(context).searchResult;
              return ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: searchResult.length + 1,
                itemBuilder: (context, index) {
                  if (snapshot.data == searchRestaurantEvent.empty) {
                    return EmptyRestaurantWidget(
                      isShowButton: false,
                    );
                  } else if (index < searchResult.length) {
                    return showContentBasedOnTextEditor(
                        searchResult[index], index);
                  } else {
                    return Container();
                  }
                },
              );
            }
          }),
    );
  }

  Widget showContentBasedOnTextEditor(dynamic data, int index) {
    final provider =
        Provider.of<SearchRestaurantProvider>(context, listen: false);
    if (provider.searchController.text.isEmpty) {
      if (index == 0) {
        return LocationNearMeWidget();
      } else {
        final mapper = data as RestaurantSearchBaseModel;
        if (mapper is RestaurantSearchTitle) {
          return Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0),
            child: Subtitle(
              title: mapper.title,
            ),
          );
        } else if (mapper is RestaurantLocalModal) {
          return rowSearch(mapper.title, mapper.subtitle, mapper.category,
              mapper.restaurantId);
        } else if (mapper is RestaurantDetail) {
          return rowSearch(mapper.name, mapper.localityVerbose,
              mapper.categoryName, mapper.id);
        } else {
          return Container();
        }
      }
    } else {
      final mapper = data as RestaurantSearchBaseModel;
      if (mapper is RestaurantSearchTitle) {
        return Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0),
          child: Subtitle(
            title: mapper.title,
          ),
        );
      } else if (mapper is RestaurantDetail) {
        return rowSearch(mapper.name, mapper.localityVerbose,
            mapper.categoryName, mapper.id);
      } else if (mapper is RestaurantLocation) {
        return rowSearch(mapper.localityVerbose, 'City',
            '${mapper.totalRestaurant} restaurants', null);
      } else {
        return Container();
      }
    }
  }

  Widget rowSearch(
      String title, String subtitle, String category, int restaurantId) {
    final provider = Provider.of<SearchRestaurantProvider>(context);
    return InkWell(
      onTap: () async {
        if (restaurantId == null) {
          Navigator.of(context).pop(title);
        } else {
          final result = await Navigator.of(context)
              .pushNamed(RestaurantDetailPage.routeName, arguments: {
            RestaurantDetailPage.restaurantId: restaurantId.toString(),
            RestaurantDetailPage.restaurantLocalModel: RestaurantLocalModal(
                title: title,
                subtitle: subtitle,
                category: category,
                dateTime: DateTime.now().millisecondsSinceEpoch,
                restaurantId: restaurantId),
          });
          if (result != null) {
            provider.addToSearchLocal();
          }
        }
      },
      child: ListTile(
        title: Text(
          title,
          style: ThemeText.rodinaHeadline,
        ),
        subtitle: Text(
          subtitle,
          style:
              ThemeText.sfMediumFootnote.copyWith(color: ThemeColors.black80),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.0),
              border: Border.all(color: ThemeColors.primaryBlue)),
          child: Text(
            category,
            style: ThemeText.sfMediumCaption
                .copyWith(color: ThemeColors.primaryBlue),
          ),
        ),
      ),
    );
  }
}
