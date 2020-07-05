import 'package:flutter/material.dart';
import 'package:localin/presentation/explore/explore_filter_page.dart';
import 'package:localin/presentation/explore/widgets/single_explore_card_widget.dart';
import 'package:localin/presentation/explore/widgets/small_category_widget.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';

class ExploreMainPageContentWidget extends StatefulWidget {
  @override
  _ExploreMainPageContentWidgetState createState() =>
      _ExploreMainPageContentWidgetState();
}

class _ExploreMainPageContentWidgetState
    extends State<ExploreMainPageContentWidget> {
  List<String> _category = [
    'Category: All',
    'Date: In the next 2 months',
    'Sort: Closed'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.black10,
      appBar: AppBar(
        titleSpacing: 0.0,
        backgroundColor: ThemeColors.black0,
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back,
            color: ThemeColors.black80,
          ),
        ),
        title: Container(
          alignment: FractionalOffset.centerLeft,
          margin: const EdgeInsets.only(right: 20.0),
          padding: const EdgeInsets.symmetric(vertical: 9.0, horizontal: 16.0),
          decoration: BoxDecoration(
            color: ThemeColors.black10,
            borderRadius: BorderRadius.circular(6.0),
          ),
          child: Text(
            'Search event, or attraction',
            style: ThemeText.sfRegularBody.copyWith(color: ThemeColors.black80),
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 32.0,
            margin: const EdgeInsets.symmetric(vertical: 10.0),
            child: ListView(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              children: List.generate(
                  _category.length,
                  (index) => InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(ExploreFilterPage.routeName);
                        },
                        child: SmallCategoryWidget(
                          marginLeft: index == 0 ? 20.0 : 8.0,
                          text: _category[index],
                        ),
                      )),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20.0),
              color: ThemeColors.black0,
              child: ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: 4 + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Event and Attraction',
                            style: ThemeText.rodinaTitle2),
                        Text(
                          'Pakualam, Serpong Utara',
                          style: ThemeText.sfMediumBody
                              .copyWith(color: ThemeColors.black80),
                        ),
                      ],
                    );
                  }
                  return SingleExploreCardWidget();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
