import 'package:flutter/material.dart';
import 'package:localin/model/community/community_category.dart';
import 'package:localin/presentation/community/community_category_search_page.dart';
import 'package:localin/presentation/community/provider/create/category_list_provider.dart';
import 'package:localin/presentation/community/provider/create/community_create_provider.dart';
import 'package:localin/presentation/shared_widgets/subtitle.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

class CommunityAddCategoryWidget extends StatefulWidget {
  final CommunityCategory category;

  CommunityAddCategoryWidget({this.category});

  @override
  _CommunityAddCategoryWidgetState createState() =>
      _CommunityAddCategoryWidgetState();
}

class _CommunityAddCategoryWidgetState
    extends State<CommunityAddCategoryWidget> {
  bool _isInit = true;
  final _scrollController = ScrollController();

  @override
  void didChangeDependencies() {
    if (_isInit) {
      if (widget.category != null) {
        Provider.of<CategoryListProvider>(context, listen: false)
            .previousCategory = widget.category;
      }
      loadData();
      _scrollController..addListener(_listener);
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  _listener() {
    if (_scrollController.offset >=
        _scrollController.position.maxScrollExtent) {
      loadData(isRefresh: false);
    }
  }

  loadData({bool isRefresh = true}) {
    Provider.of<CategoryListProvider>(context, listen: false)
        .getCategoryList(isRefresh: isRefresh);
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
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Consumer<CategoryListProvider>(
            builder: (context, provider, child) {
              return ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.only(bottom: 20.0),
                physics: ClampingScrollPhysics(),
                itemCount: 1,
                itemBuilder: (context, index) {
                  if (provider.selectedCategory.categoryName == null) {
                    return InkWell(
                      onTap: () async {
                        FocusScope.of(context).unfocus();
                        final result = await Navigator.of(context).pushNamed(
                          CommunityCategorySearch.routeName,
                        );
                        if (result != null && result is CommunityCategory) {
                          Provider.of<CategoryListProvider>(context,
                                  listen: false)
                              .selectCategory(result);
                          Provider.of<CommunityCreateProvider>(context,
                                  listen: false)
                              .selectCategory(result);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Add Category',
                          style: ThemeText.sfMediumBody
                              .copyWith(color: ThemeColors.primaryBlue),
                        ),
                      ),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 12.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(color: ThemeColors.black40),
                            ),
                            child: Text(
                              '${provider.selectedCategory?.categoryName}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: ThemeText.sfMediumBody,
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              FocusScope.of(context).unfocus();
                              final result =
                                  await Navigator.of(context).pushNamed(
                                CommunityCategorySearch.routeName,
                              );
                              if (result != null &&
                                  result is CommunityCategory) {
                                Provider.of<CategoryListProvider>(context,
                                        listen: false)
                                    .selectCategory(result);
                                Provider.of<CommunityCreateProvider>(context,
                                        listen: false)
                                    .selectCategory(result);
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.all(4.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4.0),
                                  border:
                                      Border.all(color: ThemeColors.black20)),
                              child: Text(
                                'Edit',
                                style: ThemeText.sfMediumFootnote
                                    .copyWith(color: ThemeColors.primaryBlue),
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
