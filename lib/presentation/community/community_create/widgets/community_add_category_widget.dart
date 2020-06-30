import 'package:flutter/material.dart';
import 'package:localin/model/community/community_category.dart';
import 'package:localin/presentation/community/provider/create/community_create_provider.dart';
import 'package:localin/presentation/shared_widgets/subtitle.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

class CommunityAddCategoryWidget extends StatefulWidget {
  @override
  _CommunityAddCategoryWidgetState createState() =>
      _CommunityAddCategoryWidgetState();
}

class _CommunityAddCategoryWidgetState
    extends State<CommunityAddCategoryWidget> {
  bool _isInit = true;
  Future getCategory;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      getCategory = Provider.of<CommunityCreateProvider>(context, listen: false)
          .getCategoryList();
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Subtitle(
            title: 'CATEGORY',
          ),
        ),
        SizedBox(
          height: 4,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            'Choose category for your community',
            style: ThemeText.sfRegularFootnote
                .copyWith(color: ThemeColors.black80),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 36.0, right: 20.0, left: 20.0),
          child: FutureBuilder<List<CommunityCategory>>(
            future: getCategory,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if (snapshot.hasData) {
                  return Container(
                    height: 36.0,
                    margin: EdgeInsets.only(top: 12.0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      physics: ClampingScrollPhysics(),
                      itemCount: snapshot.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        final category = snapshot.data[index];
                        return Consumer<CommunityCreateProvider>(
                          builder: (context, provider, child) {
                            return InkWell(
                              onTap: () {
                                provider.selectCategory(category);
                                FocusScope.of(context).unfocus();
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                    left: index == 0 ? 0.0 : 4.0),
                                padding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 16.0),
                                decoration: BoxDecoration(
                                    color: provider.isCategorySelected(category)
                                        ? ThemeColors.primaryBlue
                                        : ThemeColors.black0,
                                    borderRadius: BorderRadius.circular(8.0),
                                    border:
                                        Border.all(color: ThemeColors.black40)),
                                child: Text(
                                  '${category.categoryName}',
                                  maxLines: 1,
                                  style: ThemeText.sfSemiBoldFootnote.copyWith(
                                      color:
                                          provider.isCategorySelected(category)
                                              ? ThemeColors.black0
                                              : ThemeColors.black80),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                } else {
                  return Container();
                }
              }
            },
          ),
        ),
      ],
    );
  }
}
