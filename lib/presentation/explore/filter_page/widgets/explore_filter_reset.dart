import 'package:flutter/material.dart';
import 'package:localin/presentation/explore/filter_page/provider/explore_filter_provider.dart';
import 'package:provider/provider.dart';

import '../../../../text_themes.dart';
import '../../../../themes.dart';

class RowResetFilter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Provider.of<ExploreFilterProvider>(context, listen: false)
            .resetFilter();
      },
      child: Container(
        alignment: FractionalOffset.center,
        margin: const EdgeInsets.only(right: 20.0),
        child: Text('Reset Filter',
            style: ThemeText.sfMediumHeadline
                .copyWith(color: ThemeColors.primaryBlue)),
      ),
    );
  }
}
