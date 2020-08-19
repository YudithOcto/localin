import 'package:flutter/material.dart';
import 'package:localin/presentation/explore/filter_page/provider/explore_filter_provider.dart';
import 'package:localin/presentation/explore/shared_widgets/explore_filter_sliding_widget.dart';
import 'package:localin/presentation/explore/shared_widgets/explore_floating_bottom_widget.dart';
import 'package:localin/presentation/explore/shared_widgets/main_event_list.dart';
import 'package:localin/presentation/search/generic_search/search_explore_event_page.dart';
import 'package:localin/presentation/search/provider/generic_provider.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
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
                  onTap: () {
                    Navigator.of(context).pushNamed(
                        SearchExploreEventPage.routeName,
                        arguments: {
                          SearchExploreEventPage.typePage: TYPE_EVENT
                        });
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
