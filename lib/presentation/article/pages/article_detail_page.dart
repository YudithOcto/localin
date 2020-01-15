import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:localin/model/article/article_detail.dart';
import 'package:localin/presentation/article/widget/article_comment_page.dart';
import 'package:localin/presentation/article/widget/article_reader_page.dart';
import 'package:localin/presentation/article/widget/row_header_article.dart';
import 'package:localin/provider/article/article_detail_provider.dart';
import 'package:provider/provider.dart';

import '../../../themes.dart';

class ArticleDetailPage extends StatefulWidget {
  static const routeName = '/articleDetailPage';
  static const articleDetailModel = '/articleDetailModel';
  @override
  _ArticleDetailPageState createState() => _ArticleDetailPageState();
}

class _ArticleDetailPageState extends State<ArticleDetailPage> {
  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    ArticleDetail articleModel =
        routeArgs[ArticleDetailPage.articleDetailModel];
    return ChangeNotifierProvider<ArticleDetailProvider>(
      create: (_) => ArticleDetailProvider(articleModel),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 5.0,
          backgroundColor: Theme.of(context).canvasColor,
          title: Image.asset(
            'images/app_bar_logo.png',
            width: MediaQuery.of(context).size.width * 0.3,
            height: 50.0,
          ),
        ),
        body: Content(),
      ),
    );
  }
}

class Content extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = Provider.of<ArticleDetailProvider>(context);
    final width = MediaQuery.of(context).size.width;
    final orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: orientation == Orientation.portrait
                    ? width * 0.5
                    : width * 0.3,
                flexibleSpace: FlexibleSpaceBar(
                  background: Hero(
                    tag: state?.articleModel?.image,
                    child: CachedNetworkImage(
                      imageUrl: state?.articleModel?.image,
                      fit: BoxFit.fitWidth,
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                    (_, index) => RowHeaderArticle(),
                    childCount: 1),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    labelColor: Themes.primaryBlue,
                    labelStyle:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Themes.primaryBlue,
                    tabs: [
                      Tab(
                        text: "Deskripsi",
                      ),
                      Tab(text: "Komentar"),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            children: <Widget>[
              ArticleReaderPage(),
              ArticleCommentPage(),
            ],
          ),
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      color: Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
