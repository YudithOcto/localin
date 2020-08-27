import 'package:flutter/material.dart';
import 'package:localin/model/explore/explore_filter_response_model.dart';
import 'package:localin/model/explore/explorer_event_category_detail.dart';
import 'package:localin/presentation/explore/filter_page/provider/explore_filter_provider.dart';
import 'package:localin/presentation/explore/providers/explore_main_provider.dart';
import 'package:localin/presentation/explore/shared_widgets/explore_filter_sliding_widget.dart';
import 'package:localin/presentation/explore/shared_widgets/explore_floating_bottom_widget.dart';
import 'package:localin/presentation/explore/shared_widgets/main_event_list.dart';
import 'package:localin/presentation/search/provider/search_event_provider.dart';
import 'package:localin/presentation/search/search_event/search_explore_event_page.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:localin/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class ExploreMainPageContentWidget extends StatefulWidget {
  @override
  _ExploreMainPageContentWidgetState createState() =>
      _ExploreMainPageContentWidgetState();
}

class _ExploreMainPageContentWidgetState
    extends State<ExploreMainPageContentWidget> {
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<ExploreFilterProvider>(context, listen: false)
          .getFilterCategory();
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExploreFilterProvider>(
      builder: (_, provider, __) {
        return SlidingUpPanel(
          minHeight: 0.0,
          controller: provider.panelController,
          maxHeight: MediaQuery.of(context).size.height,
          panel: ExploreFilterSlidingWidget(),
          isDraggable: false,
          body: Scaffold(
              backgroundColor: ThemeColors.black10,
              appBar: AppBar(
                titleSpacing: 0.0,
                backgroundColor: ThemeColors.black0,
                leading: InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: Icon(
                    Icons.arrow_back,
                    color: ThemeColors.black80,
                  ),
                ),
                title: InkWell(
                  onTap: () async {
                    final result = await Navigator.of(context).pushNamed(
                        SearchExploreEventPage.routeName,
                        arguments: {
                          SearchExploreEventPage.typePage: TYPE_EVENT
                        });
                    final mainProvider = Provider.of<ExploreMainProvider>(
                        context,
                        listen: false);
                    if (result != null) {
                      if (result is Map<String, dynamic>) {
                        if (result.containsKey(kCategoryMap)) {
                          ExploreEventCategoryDetail categoryDetail =
                              result[kCategoryMap];
                          provider.selectCategory = CategoryExploreDetail(
                            categoryId: categoryDetail.categoryId,
                            category: categoryDetail.categoryName,
                          );
                          mainProvider.changeFilterRequest =
                              provider.eventRequestModel;
                          mainProvider.getEventList(isRefresh: true);
                        } else {
                          String location = result[kLocationMap];
                          provider.resetFilter();
                          mainProvider.changeFilterRequest =
                              provider.eventRequestModel;
                          mainProvider.searchTextValue = location;
                          mainProvider.getEventList(isRefresh: true);
                        }
                      } else {
                        mainProvider.nearby = true;
                        mainProvider.getEventList(isRefresh: true);
                      }
                    }
                  },
                  child: Container(
                    alignment: FractionalOffset.centerLeft,
                    margin: const EdgeInsets.only(right: 20.0),
                    padding: const EdgeInsets.symmetric(
                        vertical: 9.0, horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: ThemeColors.black10,
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    child: Text(
                      'Search event, or attraction',
                      style: ThemeText.sfRegularBody
                          .copyWith(color: ThemeColors.black80),
                    ),
                  ),
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              floatingActionButton: ExploreFloatingBottomWidget(),
              body: MainEventList()),
        );
      },
    );
  }
}
