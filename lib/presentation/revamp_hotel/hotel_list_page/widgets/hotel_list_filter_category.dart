import 'package:flutter/material.dart';
import 'package:localin/presentation/revamp_hotel/hotel_list_page/provider/hotel_list_filter_provider.dart';
import 'package:localin/presentation/shared_widgets/custom_category_radius.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

class HotelListFilterCategory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: ThemeColors.black0,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
      height: 60.0,
      child: Consumer<HotelListFilterProvider>(
        builder: (_, provider, __) {
          return ListView.builder(
            itemCount: 5,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return InkResponse(
                highlightColor: ThemeColors.primaryBlue,
                onTap: () {
                  provider.changeRating = index;
                },
                child: CustomCategoryRadius(
                  height: 16.0,
                  radius: 100.0,
                  marginRight: 6.0,
                  verticalPadding: 8.0,
                  horizontalPadding: 20.0,
                  buttonBackgroundColor: provider.currentRating == index
                      ? ThemeColors.primaryBlue
                      : ThemeColors.black10,
                  text: '$index star',
                  textTheme: ThemeText.sfRegularBody.copyWith(
                      color: provider.currentRating == index
                          ? ThemeColors.black0
                          : ThemeColors.black100),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
