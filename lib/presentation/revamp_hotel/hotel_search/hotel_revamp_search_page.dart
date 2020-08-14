import 'package:flutter/material.dart';
import 'package:localin/presentation/revamp_hotel/hotel_search/provider/hotel_search_provider.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:localin/utils/debounce.dart';
import 'package:provider/provider.dart';

class HotelRevampSearchPage extends StatelessWidget {
  static const routeName = 'HotelRevampSearchPage';

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<HotelSearchProvider>(
          create: (_) => HotelSearchProvider(),
        )
      ],
      child: HotelRevampSearchBuilder(),
    );
  }
}

class HotelRevampSearchBuilder extends StatefulWidget {
  @override
  _HotelRevampSearchBuilderState createState() =>
      _HotelRevampSearchBuilderState();
}

class _HotelRevampSearchBuilderState extends State<HotelRevampSearchBuilder> {
  final _debounce = Debounce(milliseconds: 400);
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
            controller: Provider.of<HotelSearchProvider>(context, listen: false)
                .searchController,
            onChanged: (v) {
//              _debounce.run(() =>
//                  Provider.of<HotelSearchProvider>(context, listen: false)
//                      .getRestaurantList(search: v));
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
      body: Container(),
//      body: StreamBuilder<HotelSearchProvider>(
//          stream: Provider.of<HotelSearchProvider>(context, listen: false)
//              .stream,
//          builder: (context, snapshot) {
//            print(snapshot);
//            if (snapshot.connectionState == ConnectionState.waiting ||
//                snapshot.hasData &&
//                    snapshot.data == searchRestaurantEvent.loading) {
//              return Center(
//                child: CircularProgressIndicator(),
//              );
//            } else {
//              final searchResult =
//                  Provider.of<SearchRestaurantProvider>(context).searchResult;
//              return ListView.builder(
//                shrinkWrap: true,
//                physics: ClampingScrollPhysics(),
//                itemCount: searchResult.length + 1,
//                itemBuilder: (context, index) {
//                  if (snapshot.data == searchRestaurantEvent.empty) {
//                    return EmptyRestaurantWidget(
//                      isShowButton: false,
//                    );
//                  } else if (index < searchResult.length) {
//                    return showContentBasedOnTextEditor(
//                        searchResult[index], index);
//                  } else {
//                    return Container();
//                  }
//                },
//              );
//            }
//          }),
    );
  }
}
