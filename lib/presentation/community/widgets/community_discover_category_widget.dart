import 'package:flutter/material.dart';
import 'package:localin/model/community/community_category.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';

class CommunityDiscoverCategoryWidget extends StatelessWidget {
  final List<CommunityCategory> communityCategoryList;
  CommunityDiscoverCategoryWidget({@required this.communityCategoryList});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      margin: EdgeInsets.only(bottom: 24.0),
      child: ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: communityCategoryList?.length ?? 0,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(left: index == 0 ? 20.0 : 8.0),
            child: ActionChip(
              padding: EdgeInsets.all(12.0),
              backgroundColor: ThemeColors.black40,
              label: Text('${communityCategoryList[index]?.categoryName}'),
              labelStyle: ThemeText.sfMediumBody,
              onPressed: () {},
            ),
          );
        },
      ),
    );
  }
}
