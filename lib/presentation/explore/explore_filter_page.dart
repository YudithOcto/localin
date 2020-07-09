import 'package:flutter/material.dart';
import 'package:localin/presentation/explore/shared_widgets/explore_single_filter_row_widget.dart';
import 'package:localin/presentation/explore/shared_widgets/custom_category_radius.dart';
import 'package:localin/presentation/shared_widgets/subtitle.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';

class ExploreFilterPage extends StatelessWidget {
  static const routeName = 'ExplorePage';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.black10,
      appBar: AppBar(
        backgroundColor: ThemeColors.black0,
        leading: Icon(
          Icons.close,
          color: ThemeColors.black80,
        ),
        titleSpacing: 0.0,
        title: Text('Filters', style: ThemeText.sfMediumHeadline),
        actions: <Widget>[
          Text('Reset Filter',
              style: ThemeText.sfMediumHeadline
                  .copyWith(color: ThemeColors.primaryBlue)),
        ],
      ),
      bottomNavigationBar: Container(
        height: 48.0,
        alignment: FractionalOffset.center,
        color: ThemeColors.primaryBlue,
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
        child: Text(
          'Apply Filter',
          style: ThemeText.rodinaTitle3.copyWith(color: ThemeColors.black0),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.only(left: 20.0, top: 24.0, bottom: 12.0),
              child: Subtitle(title: 'month'),
            ),
            Container(
              height: 36.0 + 24.0,
              color: ThemeColors.black0,
              child: ListView.builder(
                itemCount: 12,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                physics: ClampingScrollPhysics(),
                itemBuilder: (context, index) {
                  return CustomCategoryRadius(
                    marginRight: index == 11 ? 20.0 : 0.0,
                    text: 'January',
                    radius: 100.0,
                    marginBottom: 12.0,
                    marginTop: 12.0,
                    marginLeft: 6.0,
                    buttonBackgroundColor: ThemeColors.black10,
                  );
                },
              ),
            ),
            ExploreSingleFilterRowWidget(),
          ],
        ),
      ),
    );
  }
}
