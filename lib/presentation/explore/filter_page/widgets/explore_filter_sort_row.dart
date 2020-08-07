import 'package:flutter/material.dart';
import 'package:localin/presentation/explore/filter_page/provider/explore_filter_provider.dart';
import 'package:localin/presentation/explore/shared_widgets/explore_single_filter_row_widget.dart';
import 'package:localin/presentation/explore/utils/filter.dart';
import 'package:localin/presentation/shared_widgets/subtitle.dart';
import 'package:provider/provider.dart';

class ExploreFilterSortRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 20.0, bottom: 12.0),
          child: Subtitle(title: 'Sort'),
        ),
        Consumer<ExploreFilterProvider>(
          builder: (context, provider, _) {
            return Column(
                children: List.generate(
                    sortList.length,
                    (index) => ExploreSingleFilterRowWidget(
                          title: sortList[index],
                          isSelected: provider.selectedSort == null
                              ? false
                              : provider.selectedSort == index,
                          onPressed: () {
                            provider.selectSort = index;
                          },
                        )));
          },
        )
      ],
    );
  }
}
