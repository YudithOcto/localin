import 'package:flutter/material.dart';
import 'package:localin/presentation/community/provider/create/category_list_provider.dart';
import 'package:localin/presentation/search/provider/search_location_provider.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:localin/utils/debounce.dart';
import 'package:provider/provider.dart';

class CommunityCategorySearch extends StatelessWidget {
  static const routeName = 'CommunityCategorySearch';
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CategoryListProvider>(
      create: (_) => CategoryListProvider(),
      child: CommunityCategoryListWidget(),
    );
  }
}

class CommunityCategoryListWidget extends StatefulWidget {
  @override
  _CommunityCategoryListWidgetState createState() =>
      _CommunityCategoryListWidgetState();
}

class _CommunityCategoryListWidgetState
    extends State<CommunityCategoryListWidget> {
  bool _isInit = true;
  Debounce _debounce;
  final ScrollController _scrollController = ScrollController();

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _scrollController.addListener(_listener);
      Provider.of<CategoryListProvider>(context, listen: false)
          .getCategoryList(isRefresh: true);
      _debounce = Debounce(milliseconds: 300);
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  _listener() {
    if (_scrollController.offset >
        _scrollController.position.maxScrollExtent * 0.95) {
      Provider.of<CategoryListProvider>(context, listen: false)
          .getCategoryList(isRefresh: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ThemeColors.black0,
        titleSpacing: 0.0,
        leading: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: Icon(
            Icons.arrow_back,
            color: ThemeColors.black80,
          ),
        ),
        title: Container(
          height: 43.0,
          margin: EdgeInsets.only(right: 20.0),
          child: TextFormField(
            controller:
                Provider.of<CategoryListProvider>(context).searchController,
            onChanged: (v) {
              _debounce.run(() =>
                  Provider.of<CategoryListProvider>(context, listen: false)
                      .getCategoryList(isRefresh: true));
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: ThemeColors.black10,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6.0),
                  borderSide: BorderSide(color: ThemeColors.black0)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6.0),
                  borderSide: BorderSide(color: ThemeColors.black0)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6.0),
                  borderSide: BorderSide(color: ThemeColors.black0)),
              hintText: 'Search Category',
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
              hintStyle:
                  ThemeText.sfRegularBody.copyWith(color: ThemeColors.black60),
            ),
          ),
        ),
      ),
      body: StreamBuilder<categoryState>(
        stream: Provider.of<CategoryListProvider>(context, listen: false)
            .categoryStream,
        builder: (context, snapshot) {
          final provider =
              Provider.of<CategoryListProvider>(context, listen: false);
          if (snapshot.data == categoryState.loading &&
              provider.pageRequested <= 1) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.separated(
              separatorBuilder: (context, index) => Divider(),
              shrinkWrap: true,
              padding: const EdgeInsets.only(bottom: 20.0),
              physics: ClampingScrollPhysics(),
              itemCount: provider.categoryList.length + 1,
              itemBuilder: (context, index) {
                if (snapshot.data == categoryState.empty) {
                  return Container(
                    alignment: FractionalOffset.center,
                    margin: EdgeInsets.only(top: 40.0),
                    child: Text(
                      'No Category Found',
                      style: ThemeText.rodinaTitle3,
                    ),
                  );
                } else if (index < provider.categoryList.length) {
                  return ListTile(
                    onTap: () {
                      Navigator.of(context).pop(provider.categoryList[index]);
                    },
                    title: Text(
                      provider.categoryList[index].categoryName,
                      style: ThemeText.rodinaHeadline,
                    ),
                    subtitle: Text(
                      provider.categoryList[index].type,
                      style: ThemeText.sfMediumFootnote
                          .copyWith(color: ThemeColors.black80),
                    ),
                  );
                } else if (provider.canCategoryLoadMore) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Container();
                }
              },
            );
          }
        },
      ),
    );
  }
}

extension on String {
  String get titleCase {
    return this
        .toLowerCase()
        .split(' ')
        .map((e) => e.substring(0, 1).toUpperCase() + e.substring(1, e.length))
        .join(' ');
  }
}
