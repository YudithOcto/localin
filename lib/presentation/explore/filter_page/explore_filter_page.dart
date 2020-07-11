import 'package:flutter/material.dart';
import 'package:localin/presentation/explore/filter_page/provider/explore_filter_provider.dart';
import 'package:localin/presentation/explore/filter_page/widgets/explore_filter_category.dart';
import 'package:localin/presentation/explore/filter_page/widgets/explore_filter_month.dart';
import 'package:localin/presentation/explore/filter_page/widgets/explore_filter_reset.dart';
import 'package:localin/presentation/explore/filter_page/widgets/explore_filter_sort_row.dart';
import 'package:localin/presentation/shared_widgets/subtitle.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

class ExploreFilterPage extends StatelessWidget {
  static const routeName = 'ExplorePage';
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ExploreFilterProvider>(
      create: (_) => ExploreFilterProvider(),
      child: ExploreFilterWrapper(),
    );
  }
}

class ExploreFilterWrapper extends StatefulWidget {
  @override
  _ExploreFilterWrapperState createState() => _ExploreFilterWrapperState();
}

class _ExploreFilterWrapperState extends State<ExploreFilterWrapper> {
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<ExploreFilterProvider>(context, listen: false)
          .getFilterCategory();
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.black10,
      appBar: AppBar(
        backgroundColor: ThemeColors.black0,
        leading: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: Icon(
            Icons.close,
            color: ThemeColors.black80,
          ),
        ),
        titleSpacing: 0.0,
        title: Text('Filters', style: ThemeText.sfMediumHeadline),
        actions: <Widget>[
          RowResetFilter(),
        ],
      ),
      bottomNavigationBar: Container(
        height: 48.0,
        alignment: FractionalOffset.center,
        color: ThemeColors.primaryBlue,
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
        child: Text(
          'Apply Filter',
          style: ThemeText.rodinaTitle3.copyWith(color: ThemeColors.black0),
        ),
      ),
      body: StreamBuilder<filterState>(
          stream:
              Provider.of<ExploreFilterProvider>(context, listen: false).stream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, top: 24.0, bottom: 12.0),
                    child: Subtitle(title: 'month'),
                  ),
                  Container(
                    height: 36.0 + 24.0,
                    color: ThemeColors.black0,
                    child: ExploreFilterMonth(),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 24.0),
                    child: ExploreFilterSortRow(),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 24.0),
                    child: ExploreFilterCategory(),
                  )
                ],
              ),
            );
          }),
    );
  }
}
