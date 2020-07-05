import 'package:flutter/material.dart';
import 'package:localin/presentation/explore/widgets/small_category_widget.dart';
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Subtitle(title: 'month'),
            Container(
              color: ThemeColors.black0,
              height: 60.0,
              child: ListView.builder(
                itemCount: 12,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                physics: ClampingScrollPhysics(),
                itemBuilder: (context, index) {
                  return SmallCategoryWidget(
                    text: 'January',
                    radius: 100.0,
                    buttonBackgroundColor: ThemeColors.black10,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
