import 'package:flutter/material.dart';
import 'package:localin/presentation/explore/filter_page/provider/explore_filter_provider.dart';
import 'package:localin/presentation/explore/shared_widgets/custom_category_radius.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

class ExploreFilterMonth extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ExploreFilterProvider>(
      builder: (context, provider, _) {
        return ListView.builder(
          itemCount: provider.monthList.length,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          physics: ClampingScrollPhysics(),
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                provider.selectMonth = index;
              },
              child: CustomCategoryRadius(
                marginRight: index == 11 ? 20.0 : 0.0,
                text: provider.monthList[index],
                radius: 100.0,
                marginBottom: 12.0,
                marginTop: 12.0,
                marginLeft: 6.0,
                textTheme: ThemeText.sfMediumFootnote.copyWith(
                    color: provider.selectedMonth != null &&
                            index == provider.selectedMonth
                        ? ThemeColors.black0
                        : ThemeColors.black100),
                buttonBackgroundColor: provider.selectedMonth != null &&
                        index == provider.selectedMonth
                    ? ThemeColors.primaryBlue
                    : ThemeColors.black10,
              ),
            );
          },
        );
      },
    );
  }
}
