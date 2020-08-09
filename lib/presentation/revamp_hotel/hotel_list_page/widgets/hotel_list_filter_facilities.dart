import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localin/presentation/revamp_hotel/hotel_list_page/provider/hotel_list_filter_provider.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

class HotelListFilterFacilities extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<HotelListFilterProvider>(builder: (_, provider, __) {
      return ListView.separated(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemCount: provider.facilities.length,
          separatorBuilder: (_, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Divider(
                height: 0.0,
                color: ThemeColors.black10,
                thickness: 1.5,
              ),
            );
          },
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                provider.selectFacility = index;
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 20.0),
                color: ThemeColors.black0,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      '${provider.facilities[index]}',
                      style: ThemeText.sfRegularBody,
                    ),
                    SvgPicture.asset(
                        'images/${provider.isFacilitySelected(index) ? 'checkbox_checked_blue' : 'checkbox_uncheck'}.svg'),
                  ],
                ),
              ),
            );
          });
    });
  }
}
