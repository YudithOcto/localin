import 'package:flutter/material.dart';
import 'package:localin/presentation/explore/filter_page/explore_filter_page.dart';
import 'package:localin/presentation/explore/providers/explore_main_provider.dart';
import 'package:localin/presentation/explore/shared_widgets/main_event_list.dart';
import 'package:localin/presentation/explore/shared_widgets/single_explore_card_widget.dart';
import 'package:localin/presentation/explore/shared_widgets/custom_category_radius.dart';
import 'package:localin/presentation/search/generic_search/search_explore_event_page.dart';
import 'package:localin/presentation/search/provider/generic_provider.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

class ExploreMainPageContentWidget extends StatefulWidget {
  @override
  _ExploreMainPageContentWidgetState createState() =>
      _ExploreMainPageContentWidgetState();
}

class _ExploreMainPageContentWidgetState
    extends State<ExploreMainPageContentWidget> {
  List<String> _category = [
    'Category: All',
    'Date: In the next 2 months',
    'Sort: Closed'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.black10,
      appBar: AppBar(
        titleSpacing: 0.0,
        backgroundColor: ThemeColors.black0,
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back,
            color: ThemeColors.black80,
          ),
        ),
        title: InkWell(
          onTap: () {
            Navigator.of(context).pushNamed(SearchExploreEventPage.routeName,
                arguments: {SearchExploreEventPage.typePage: TYPE_EVENT});
          },
          child: Container(
            alignment: FractionalOffset.centerLeft,
            margin: const EdgeInsets.only(right: 20.0),
            padding:
                const EdgeInsets.symmetric(vertical: 9.0, horizontal: 16.0),
            decoration: BoxDecoration(
              color: ThemeColors.black10,
              borderRadius: BorderRadius.circular(6.0),
            ),
            child: Text(
              'Search event, or attraction',
              style:
                  ThemeText.sfRegularBody.copyWith(color: ThemeColors.black80),
            ),
          ),
        ),
      ),
      body: ChangeNotifierProvider<ExploreMainProvider>(
        create: (_) => ExploreMainProvider(),
        child: Column(
          children: <Widget>[
            Container(
              height: 32.0,
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              child: ListView(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                children: List.generate(
                    _category.length,
                    (index) => InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(ExploreFilterPage.routeName);
                          },
                          child: CustomCategoryRadius(
                            marginLeft: index == 0 ? 20.0 : 8.0,
                            text: _category[index],
                          ),
                        )),
              ),
            ),
            MainEventList(),
          ],
        ),
      ),
    );
  }
}
