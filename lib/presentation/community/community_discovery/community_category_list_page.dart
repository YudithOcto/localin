import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localin/components/custom_app_bar.dart';
import 'package:localin/presentation/community/community_search/search_community_page.dart';
import 'package:localin/presentation/community/provider/community_category_provider.dart';
import 'package:provider/provider.dart';

class CommunityCategoryListPage extends StatelessWidget {
  static const routeName = 'CommunityCategoryPage';
  static const categorySlug = 'categorySlug';
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CommunityCategoryProvider>(
      create: (_) => CommunityCategoryProvider(),
      child: CommunityByCategoryContentWidget(),
    );
  }
}

class CommunityByCategoryContentWidget extends StatefulWidget {
  @override
  _CommunityByCategoryContentWidgetState createState() =>
      _CommunityByCategoryContentWidgetState();
}

class _CommunityByCategoryContentWidgetState
    extends State<CommunityByCategoryContentWidget> {
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final routeArgs =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      String catId = routeArgs[CommunityCategoryListPage.categorySlug];
      Provider.of<CommunityCategoryProvider>(context, listen: false)
          .getPopularCommunity(categoryId: catId);
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        pageTitle: 'Community',
        appBar: AppBar(),
        flexSpace: SafeArea(
            child: InkWell(
          onTap: () async {
            await Navigator.of(context).pushNamed(SearchCommunity.routeName);
          },
          child: Container(
              alignment: FractionalOffset.centerRight,
              margin: EdgeInsets.only(right: 20.0),
              child: SvgPicture.asset('images/search_grey.svg')),
        )),
      ),
    );
  }
}
