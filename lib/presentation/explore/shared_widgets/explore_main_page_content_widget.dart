import 'package:flutter/material.dart';
import 'package:localin/presentation/explore/filter_page/explore_filter_page.dart';
import 'package:localin/presentation/explore/providers/explore_main_filter_provider.dart';
import 'package:localin/presentation/explore/providers/explore_main_provider.dart';
import 'package:localin/presentation/explore/shared_widgets/main_event_list.dart';
import 'package:localin/presentation/explore/shared_widgets/custom_category_radius.dart';
import 'package:localin/presentation/explore/utils/filter.dart';
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
            ExploreFilterListRow(),
            MainEventList(),
          ],
        ),
      ),
    );
  }
}

class ExploreFilterListRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ExploreMainFilterProvider>(
      builder: (context, provider, _) {
        return Container(
          height: 32.0,
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: List.generate(3, (index) {
              return InkWell(
                onTap: () async {
                  final filterResult = await Navigator.of(context)
                      .pushNamed(ExploreFilterPage.routeName, arguments: {
                    ExploreFilterPage.previousFilterModel:
                        provider.eventRequestModel,
                  });
                  if (filterResult != null) {
                    provider.addFilter(filterResult);
                    List<String> categoryId =
                        provider.selectedCategoryFilter != null &&
                                provider.selectedCategoryFilter.isNotEmpty
                            ? provider.selectedCategoryFilter
                                .map((e) => e.categoryId)
                                .toList()
                            : List();
                    Provider.of<ExploreMainProvider>(context, listen: false)
                        .getEventList(
                      isRefresh: true,
                      categoryId: categoryId,
                      sort: provider.selectedFilter[2],
                      date:
                          '${DateTime.now().year}-${monthList.indexOf(provider.selectedFilter[1]) + 1}',
                    );
                  }
                },
                child: CustomCategoryRadius(
                  marginLeft: index == 0 ? 20.0 : 8.0,
                  text: '${title(index)}${provider.selectedFilter[index]}',
                ),
              );
            }),
          ),
        );
      },
    );
  }

  String title(int index) {
    switch (index) {
      case 0:
        return 'Category: ';
        break;
      case 1:
        return 'Date: ';
        break;
      case 2:
        return 'Sort: ';
        break;
    }
    return '';
  }
}
