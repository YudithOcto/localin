import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localin/components/custom_app_bar.dart';
import 'package:localin/model/community/community_category.dart';
import 'package:localin/presentation/community/community_discovery/widget/community_category_other_list.dart';
import 'package:localin/presentation/community/community_discovery/widget/community_category_popular_list.dart';
import 'package:localin/presentation/community/community_search/search_community_page.dart';
import 'package:localin/presentation/community/provider/community_category_provider.dart';
import 'package:localin/presentation/community/provider/community_nearby_provider.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

class CommunityCategoryListPage extends StatelessWidget {
  static const routeName = 'CommunityCategoryPage';
  static const categoryDetail = 'categoryDetail';
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CommunityCategoryProvider>(
          create: (_) => CommunityCategoryProvider(),
        ),
        ChangeNotifierProvider<CommunityNearbyProvider>(
          create: (_) => CommunityNearbyProvider(),
        ),
      ],
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
  CommunityCategory _catDetail;
  String _categoryName = '';

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final routeArgs =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      _catDetail = routeArgs[CommunityCategoryListPage.categoryDetail];
      _categoryName = _catDetail.categoryName;
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ThemeColors.black0,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back,
            color: ThemeColors.black80,
          ),
        ),
        titleSpacing: 0.0,
        title: Container(
          margin: EdgeInsets.only(right: 80.0),
          child: RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                    text: 'Communities in ',
                    style: ThemeText.sfMediumHeadline
                        .copyWith(color: ThemeColors.black80)),
                TextSpan(
                    text: _categoryName, style: ThemeText.sfMediumHeadline),
              ],
            ),
          ),
        ),
        flexibleSpace: SafeArea(
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
      body: SingleChildScrollView(
        child: ListView(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          children: <Widget>[
            CommunityCategoryPopularList(
              categoryId: _catDetail.id,
            ),
            CommunityCategoryOtherList(categoryId: _catDetail.id)
          ],
        ),
      ),
    );
  }
}
