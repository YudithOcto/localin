import 'package:flutter/material.dart';
import 'package:localin/presentation/explore/filter_page/provider/explore_filter_provider.dart';
import 'package:localin/presentation/explore/shared_widgets/explore_single_filter_row_widget.dart';
import 'package:localin/presentation/shared_widgets/subtitle.dart';
import 'package:provider/provider.dart';

class ExploreFilterCategory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 20.0, bottom: 12.0),
          child: Subtitle(title: 'Category'),
        ),
        Consumer<ExploreFilterProvider>(
          builder: (context, provider, _) {
            return Column(
                children: List.generate(
                    provider.listCategory.length,
                    (index) => ExploreSingleFilterRowWidget(
                          title: provider.listCategory[index].category,
                          isSelected: provider.selectedCategory
                              .contains(provider.listCategory[index]),
                          onPressed: () {
                            provider.selectCategory =
                                provider.listCategory[index];
                          },
                        )));
          },
        )
      ],
    );
  }
}
