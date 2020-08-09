import 'package:flutter/material.dart';
import 'package:localin/presentation/revamp_hotel/hotel_list_page/provider/hotel_list_provider.dart';
import 'package:localin/presentation/shared_widgets/custom_sorting_widget.dart';
import 'package:localin/themes.dart';
import 'package:localin/utils/constants.dart';
import 'package:provider/provider.dart';

import 'bottom_row_widget.dart';

class HotelListFloatingBottomWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
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
            InkResponse(
              onTap: () {
                Provider.of<HotelListProvider>(context, listen: false)
                    .panelController
                    .animatePanelToPosition(1.0,
                        duration: Duration(milliseconds: 250));
              },
              child: BottomRowWidget(
                title: 'Filter',
                icon: 'images/icon_filter.svg',
              ),
            ),
          ],
        ));
  }
}
