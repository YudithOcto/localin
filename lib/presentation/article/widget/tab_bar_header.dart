import 'package:flutter/material.dart';
import 'package:localin/presentation/article/widget/article_comment_page.dart';
import 'package:localin/presentation/article/widget/article_reader_page.dart';
import '../../../themes.dart';

class TabBarHeader extends StatefulWidget {
  @override
  _TabBarHeaderState createState() => _TabBarHeaderState();
}

class _TabBarHeaderState extends State<TabBarHeader>
    with SingleTickerProviderStateMixin {
  int tabIndex = 0;
  List<Widget> _createTab(BuildContext context) {
    return [
      Tab(
        text: 'Deskripsi',
      ),
      Tab(
        text: 'Komentar',
      )
    ];
  }

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 500,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          bottom: TabBar(
            tabs: _createTab(context),
            labelColor: Themes.primaryBlue,
            labelStyle: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600),
            unselectedLabelColor: Colors.grey,
            indicatorColor: Themes.primaryBlue,
            controller: _tabController,
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            ArticleReaderPage(),
            ArticleCommentPage(),
          ],
          controller: _tabController,
        ),
      ),
    );
  }
}
