import 'package:flutter/material.dart';
import 'package:localin/presentation/explore/providers/explore_main_filter_provider.dart';
import 'package:localin/presentation/explore/providers/explore_main_provider.dart';
import 'package:localin/presentation/explore/shared_widgets//explore_main_page_content_widget.dart';
import 'package:provider/provider.dart';

class ExploreMainPage extends StatelessWidget {
  static const routeName = 'ExploreMainPage';

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ExploreMainProvider>(
          create: (_) => ExploreMainProvider(),
        ),
        ChangeNotifierProvider<ExploreMainFilterProvider>(
          create: (_) => ExploreMainFilterProvider(),
        )
      ],
      child: ExploreMainPageContentWidget(),
    );
  }
}
