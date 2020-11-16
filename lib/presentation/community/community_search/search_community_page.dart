import 'package:flutter/material.dart';
import 'package:localin/presentation/community/community_search/widget/search_community_content_widget.dart';
import 'package:localin/presentation/community/provider/search/search_community_provider.dart';
import 'package:provider/provider.dart';

class SearchCommunity extends StatelessWidget {
  static const routeName = 'SearchCommunityPage';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SearchCommunityProvider>(
      create: (_) => SearchCommunityProvider(),
      child: SearchCommunityContentWidget(),
    );
  }
}
