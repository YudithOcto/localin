import 'package:flutter/material.dart';
import 'package:localin/presentation/community/community_discovery/community_category_list_page.dart';
import 'package:localin/presentation/community/provider/create/category_list_provider.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

class CommunityDiscoverCategoryWidget extends StatefulWidget {
  @override
  _CommunityDiscoverCategoryWidgetState createState() =>
      _CommunityDiscoverCategoryWidgetState();
}

class _CommunityDiscoverCategoryWidgetState
    extends State<CommunityDiscoverCategoryWidget> {
  bool _isInit = true;
  final _scrollController = ScrollController();
  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<CategoryListProvider>(context, listen: false)
          .getCategoryList(byLocation: 1);
      _scrollController..addListener(_listener);
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  _listener() {
    if (_scrollController.offset >=
        _scrollController.position.maxScrollExtent) {
      Provider.of<CategoryListProvider>(context, listen: false)
          .getCategoryList(isRefresh: false, byLocation: 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44.0,
      margin: EdgeInsets.only(bottom: 24.0),
      child: StreamBuilder<categoryState>(
          stream: Provider.of<CategoryListProvider>(context, listen: false)
              .categoryStream,
          builder: (context, snapshot) {
            return Consumer<CategoryListProvider>(
              builder: (context, provider, child) {
                return ListView.builder(
                  shrinkWrap: true,
                  controller: _scrollController,
                  physics: ClampingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: provider.categoryList.length + 1,
                  itemBuilder: (context, index) {
                    if (snapshot.data == categoryState.empty) {
                      return Container();
                    } else if (index < provider.categoryList.length) {
                      final item = provider.categoryList[index];
                      return Container(
                        margin: EdgeInsets.only(left: index == 0 ? 20.0 : 8.0),
                        child: ActionChip(
                          padding: EdgeInsets.all(12.0),
                          backgroundColor: ThemeColors.black40,
                          label: Text('${item.categoryName}'),
                          labelStyle: ThemeText.sfMediumBody,
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                                CommunityCategoryListPage.routeName,
                                arguments: {
                                  CommunityCategoryListPage.categoryDetail:
                                      item,
                                });
                          },
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                );
              },
            );
          }),
    );
  }
}
