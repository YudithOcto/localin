import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localin/presentation/revamp_hotel/hotel_list_page/provider/hotel_list_provider.dart';
import 'package:localin/presentation/revamp_hotel/hotel_list_page/provider/hotel_list_search_provider.dart';
import 'package:localin/presentation/revamp_hotel/hotel_list_page/widgets/appbar_detail_content_widget.dart';
import 'package:localin/presentation/revamp_hotel/hotel_list_page/widgets/bottom_row_widget.dart';
import 'package:localin/presentation/revamp_hotel/hotel_list_page/widgets/hotel_single_row_widget.dart';
import 'package:localin/presentation/revamp_hotel/hotel_list_page/widgets/quick_search_row_widget.dart';
import 'package:localin/presentation/shared_widgets/custom_sorting_widget.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/utils/constants.dart';
import 'package:provider/provider.dart';

import '../../../themes.dart';

class HotelListPage extends StatelessWidget {
  static const routeName = 'HotelListPage';
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<HotelListProvider>(
          create: (_) => HotelListProvider(),
        ),
      ],
      child: HotelListBuilder(),
    );
  }
}

class HotelListBuilder extends StatefulWidget {
  @override
  _HotelListBuilderState createState() => _HotelListBuilderState();
}

class _HotelListBuilderState extends State<HotelListBuilder> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.black10,
      appBar: AppBar(
        backgroundColor: ThemeColors.black0,
        title: Consumer<HotelListProvider>(
          builder: (_, provider, __) {
            return provider.showSearchAppBar
                ? AppBarDetailContentWidget()
                : Text(
                    'Stay',
                    style: ThemeText.sfMediumHeadline,
                  );
          },
        ),
        titleSpacing: 0.0,
        leading: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: Icon(Icons.arrow_back, color: ThemeColors.black80),
        ),
        actions: <Widget>[
          Consumer<HotelListProvider>(
            builder: (_, provider, __) {
              return Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: provider.showSearchAppBar
                    ? InkResponse(
                        highlightColor: ThemeColors.primaryBlue,
                        onTap: () async {},
                        child: SvgPicture.asset('images/search_grey.svg'))
                    : InkResponse(
                        highlightColor: ThemeColors.primaryBlue,
                        onTap: () async {},
                        child: SvgPicture.asset('images/bookmark_full.svg',
                            color: ThemeColors.primaryBlue),
                      ),
              );
            },
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
          height: 56.0,
          width: 190.0,
          decoration: BoxDecoration(
            color: ThemeColors.black0,
            borderRadius: BorderRadius.circular(4.0),
          ),
          alignment: FractionalOffset.bottomCenter,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InkResponse(
                highlightColor: ThemeColors.primaryBlue,
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return CustomSortingWidget(
                          onTap: (index) {},
                          sortingTitle: [
                            kHighestPopularity,
                            kLowestPrice,
                            kHighestPrice,
                            kHighestRating,
                          ],
                          currentSelectedSort: 0,
                        );
                      });
                },
                child: BottomRowWidget(
                  title: 'Sort',
                  icon: 'images/sort_icon.svg',
                ),
              ),
              Container(
                color: ThemeColors.black60,
                width: 1.0,
                height: 20.0,
              ),
              BottomRowWidget(
                title: 'Filter',
                icon: 'images/icon_filter.svg',
              ),
            ],
          )),
      body: Consumer<HotelListProvider>(
        builder: (_, provider, __) {
          return ListView.builder(
            itemCount: 4,
            controller: provider.scrollController,
            padding: const EdgeInsets.only(bottom: 80.0),
            itemBuilder: (context, index) {
              if (index == 0) {
                return QuickSearchRowWidget();
              } else {
                return HotelSingleRowWidget();
              }
            },
          );
        },
      ),
    );
  }
}
