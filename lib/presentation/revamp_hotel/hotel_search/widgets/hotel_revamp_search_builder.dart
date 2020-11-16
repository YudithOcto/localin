import 'package:flutter/material.dart';
import 'package:localin/model/hotel/hotel_search_suggest_model.dart';
import 'package:localin/model/hotel/hotel_suggest_base.dart';
import 'package:localin/model/hotel/hotel_suggest_local_model.dart';
import 'package:localin/model/hotel/hotel_suggest_nearby.dart';
import 'package:localin/model/hotel/hotel_suggest_title.dart';
import 'package:localin/presentation/restaurant/shared_widget/location_near_me_widget.dart';
import 'package:localin/presentation/revamp_hotel/hotel_detail_page/hotel_detail_revamp_page.dart';
import 'package:localin/presentation/revamp_hotel/hotel_search/hotel_revamp_search_page.dart';
import 'package:localin/presentation/revamp_hotel/hotel_search/provider/hotel_search_provider.dart';
import 'package:localin/presentation/revamp_hotel/hotel_search/widgets/hotel_search_single_widget.dart';
import 'package:localin/presentation/revamp_hotel/shared_widgets/hotel_empty_widget.dart';
import 'package:localin/presentation/search/provider/search_event_provider.dart';
import 'package:localin/presentation/shared_widgets/subtitle.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:localin/utils/debounce.dart';
import 'package:provider/provider.dart';

class HotelRevampSearchBuilder extends StatefulWidget {
  @override
  _HotelRevampSearchBuilderState createState() =>
      _HotelRevampSearchBuilderState();
}

class _HotelRevampSearchBuilderState extends State<HotelRevampSearchBuilder> {
  final _debounce = Debounce(milliseconds: 400);
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<HotelSearchProvider>(context, listen: false).searchHotel();
      _isInit = false;
    }
    super.didChangeDependencies();
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
                Provider.of<HotelSearchProvider>(context).searchController,
            onChanged: (v) {
              _debounce.run(() =>
                  Provider.of<HotelSearchProvider>(context, listen: false)
                      .searchHotel());
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
              hintText: 'Search for Hotel, City or Location',
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
              hintStyle:
                  ThemeText.sfRegularBody.copyWith(color: ThemeColors.black60),
            ),
          ),
        ),
      ),
      body: StreamBuilder<searchState>(
          stream:
              Provider.of<HotelSearchProvider>(context, listen: false).stream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting ||
                (snapshot.hasData && snapshot.data == searchState.loading)) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              final searchResult =
                  Provider.of<HotelSearchProvider>(context).hotelList;
              return ListView.separated(
                separatorBuilder: (context, index) {
                  if (searchResult[index] is HotelSuggestTitle) {
                    return Container();
                  } else {
                    return Divider(
                      thickness: 1.5,
                      color: ThemeColors.black20,
                    );
                  }
                },
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: searchResult.length + 1,
                itemBuilder: (context, index) {
                  if (snapshot.data == searchState.empty) {
                    return HotelEmptyWidget(
                      isVisible: false,
                    );
                  } else if (index < searchResult.length) {
                    return showContentBasedOnTextEditor(
                        searchResult[index], index, context);
                  } else {
                    return Container();
                  }
                },
              );
            }
          }),
    );
  }

  showContentBasedOnTextEditor(
      HotelSuggestBase base, int index, BuildContext context) {
    if (base is HotelSuggestTitle) {
      return Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 20.0, top: 30.0),
        child: Subtitle(
          title: base.title,
        ),
      );
    } else if (base is SuggestHotelModel) {
      return HotelSearchSingleWidget(
        onTap: () async {
          final route =
              ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
          Navigator.of(context)
              .pushNamed(HotelRevampDetailPage.routeName, arguments: {
            HotelRevampDetailPage.hotelId: base.id,
            HotelRevampDetailPage.previousSort:
                route[HotelRevampSearchPage.hotelRevampRequest],
          });
        },
        title: base.suggest,
        subtitle: base.address,
        category: 'Hotels',
      );
    } else if (base is SuggestLocationModel) {
      return HotelSearchSingleWidget(
        onTap: () {
          Provider.of<HotelSearchProvider>(context)
              .addToSearchLocal(HotelSuggestLocalModel(
            title: base.suggest,
            subtitle: 'City',
            category: '${base.total} hotel(s)',
            hotelId: DateTime.now().millisecondsSinceEpoch,
          ));
          Navigator.of(context).pop(base.suggest);
        },
        title: base.suggest,
        subtitle: 'City',
        category: '${base.total} hotel(s)',
      );
    } else if (base is HotelSuggestLocalModel) {
      return HotelSearchSingleWidget(
        onTap: () {
          if (base.subtitle == 'City') {
            Navigator.of(context).pop(base.title);
          } else {
            final route = ModalRoute.of(context).settings.arguments
                as Map<String, dynamic>;
            Navigator.of(context)
                .pushNamed(HotelRevampDetailPage.routeName, arguments: {
              HotelRevampDetailPage.hotelId: base.hotelId,
              HotelRevampDetailPage.previousSort:
                  route[HotelRevampSearchPage.hotelRevampRequest],
            });
          }
        },
        title: base.title,
        subtitle: base.subtitle,
        category: base.category,
      );
    } else if (base is HotelSuggestNearby) {
      return LocationNearMeWidget(
        title: 'Hotel Near Me',
      );
    }
  }
}
