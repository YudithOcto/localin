import 'package:flutter/material.dart';
import 'package:localin/presentation/explore/filter_page/provider/explore_filter_provider.dart';
import 'package:localin/presentation/explore/providers/explore_main_provider.dart';
import 'package:localin/presentation/explore/utils/filter.dart';
import 'package:localin/presentation/revamp_hotel/hotel_list_page/widgets/bottom_row_widget.dart';
import 'package:localin/presentation/shared_widgets/custom_sorting_widget.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

class ExploreFloatingBottomWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      child: Container(
          height: 56.0,
          width: 190.0,
          decoration: BoxDecoration(
            color: ThemeColors.black0,
            borderRadius: BorderRadius.circular(4.0),
          ),
          alignment: FractionalOffset.bottomCenter,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InkResponse(
                highlightColor: ThemeColors.primaryBlue,
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (ctx) {
                        return CustomSortingWidget(
                          onTap: (sort) {
                            final provider = Provider.of<ExploreMainProvider>(
                                context,
                                listen: false);
                            Navigator.of(context).pop();
                            Provider.of<ExploreFilterProvider>(context,
                                    listen: false)
                                .selectSort = sortList.indexOf(sort);
                            provider.changeFilterRequest =
                                Provider.of<ExploreFilterProvider>(context,
                                        listen: false)
                                    .eventRequestModel;
                          },
                          sortingTitle: sortList,
                          currentSelectedSort:
                              Provider.of<ExploreFilterProvider>(context)
                                  .selectedSort,
                        );
                      });
                },
                child: BottomRowWidget(
                  title: 'Sort',
                  icon: 'images/sort_icon.svg',
                ),
              ),
              Container(
                color: ThemeColors.black60,
                width: 1.0,
                height: 20.0,
              ),
              InkResponse(
                onTap: () {
                  Provider.of<ExploreFilterProvider>(context, listen: false)
                      .panelController
                      .animatePanelToPosition(1.0,
                          duration: Duration(milliseconds: 250));
                },
                child: BottomRowWidget(
                  title: 'Filter',
                  icon: 'images/icon_filter.svg',
                ),
              ),
            ],
          )),
    );
  }
}
