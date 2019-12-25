import 'package:flutter/material.dart';
import 'package:localin/presentation/article/widget/TabsViewDynamic.dart';
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
    return Column(
      children: <Widget>[
        TabBar(
          onTap: (value) {
            setState(() {
              tabIndex = value;
              _tabController.animateTo(value);
            });
          },
          tabs: _createTab(context),
          labelColor: Themes.primaryBlue,
          labelStyle: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600),
          unselectedLabelColor: Colors.grey,
          indicatorColor: Themes.primaryBlue,
          controller: _tabController,
        ),
        GestureDetector(
          onPanUpdate: (details) {
            if (details.delta.dx < 0 && tabIndex == 0) {
              //swiping right
              setState(() {
                tabIndex = 1;
                _tabController.animateTo(1);
              });
            } else if (details.delta.dx > 0 && tabIndex == 1) {
              setState(() {
                tabIndex = 0;
                _tabController.animateTo(0);
              });
            }
          },
          child: TabsViewDynamic(
            tabIndex: tabIndex,
            firstTab: ArticleReaderPage(),
            secondTab: ArticleCommentPage(),
          ),
        )
      ],
    );
  }
}
