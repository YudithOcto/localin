import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localin/presentation/search/provider/search_article_provider.dart';
import 'package:localin/presentation/search/search_widgets/search_article_result_widget.dart';
import 'package:localin/presentation/search/search_widgets/search_tag_result_widget.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

class SearchArticlePageContent extends StatefulWidget {
  @override
  _SearchArticlePageContentState createState() =>
      _SearchArticlePageContentState();
}

class _SearchArticlePageContentState extends State<SearchArticlePageContent>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController tabController;
  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 2);
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
          child: Consumer<SearchArticleProvider>(
            builder: (context, provider, child) {
              return TextFormField(
                controller: provider.searchController,
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
                  hintText: 'Search Local News',
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  suffixIcon: Visibility(
                    visible: provider.isClearButtonVisible,
                    child: SvgPicture.asset(
                      'images/clear_icon.svg',
                      fit: BoxFit.scaleDown,
                      width: 5.0,
                      height: 5.0,
                    ),
                  ),
                  hintStyle: ThemeText.sfRegularBody
                      .copyWith(color: ThemeColors.black60),
                ),
              );
            },
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Align(
            alignment: FractionalOffset.centerLeft,
            child: TabBar(
              controller: tabController,
              isScrollable: true,
              unselectedLabelColor: ThemeColors.black60,
              unselectedLabelStyle: ThemeText.sfSemiBoldBody,
              labelColor: ThemeColors.primaryBlue,
              labelStyle: ThemeText.sfSemiBoldBody,
              onTap: (index) => _pageController.jumpToPage(index),
              tabs: <Widget>[
                Tab(
                  text: 'Articles',
                ),
                Tab(
                  text: 'Tags',
                ),
              ],
            ),
          ),
        ),
      ),
      body: PageView(
        controller: _pageController,
        children: <Widget>[
          SearchArticleResultWidget(),
          SearchTagResultWidget(),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
