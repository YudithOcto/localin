import 'package:flutter/material.dart';
import 'package:localin/presentation/explore/filter_page/provider/explore_filter_provider.dart';
import 'package:localin/presentation/explore/filter_page/widgets/explore_filter_category.dart';
import 'package:localin/presentation/explore/filter_page/widgets/explore_filter_month.dart';
import 'package:localin/presentation/explore/filter_page/widgets/explore_filter_reset.dart';
import 'package:localin/presentation/explore/providers/explore_main_provider.dart';
import 'package:localin/presentation/shared_widgets/subtitle.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

class ExploreFilterSlidingWidget extends StatefulWidget {
  @override
  _ExploreFilterSlidingWidgetState createState() =>
      _ExploreFilterSlidingWidgetState();
}

class _ExploreFilterSlidingWidgetState
    extends State<ExploreFilterSlidingWidget> {
  onBackPressed() {
    final provider = Provider.of<ExploreFilterProvider>(context);
    if (provider.panelController.isPanelOpen) {
      provider.panelController
          .animatePanelToPosition(0.0, duration: Duration(milliseconds: 250));
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        onBackPressed();
        return false;
      },
      child: Scaffold(
        backgroundColor: ThemeColors.black10,
        appBar: AppBar(
          backgroundColor: ThemeColors.black0,
          leading: InkWell(
            onTap: () {
              onBackPressed();
            },
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
        bottomNavigationBar: InkWell(
          onTap: () {
            final model =
                Provider.of<ExploreFilterProvider>(context).eventRequestModel;
            Provider.of<ExploreFilterProvider>(context, listen: false)
                .panelController
                .animatePanelToPosition(0.0,
                    duration: Duration(milliseconds: 250));
            Provider.of<ExploreMainProvider>(context, listen: false)
                .changeFilterRequest = model;
          },
          child: Container(
            height: 48.0,
            alignment: FractionalOffset.center,
            color: ThemeColors.primaryBlue,
            padding:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
            child: Text(
              'Apply Filter',
              style: ThemeText.rodinaTitle3.copyWith(color: ThemeColors.black0),
            ),
          ),
        ),
        body: StreamBuilder<filterState>(
            stream: Provider.of<ExploreFilterProvider>(context, listen: false)
                .stream,
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
                      child: ExploreFilterCategory(),
                    )
                  ],
                ),
              );
            }),
      ),
    );
  }
}
