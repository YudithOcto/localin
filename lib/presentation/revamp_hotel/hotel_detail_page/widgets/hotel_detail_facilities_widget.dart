import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localin/presentation/revamp_hotel/hotel_detail_page/hotel_detail_all_facilities_page.dart';
import 'package:localin/presentation/revamp_hotel/hotel_detail_page/provider/hotel_detail_api_provider.dart';
import 'package:localin/presentation/shared_widgets/subtitle.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

class HotelDetailFacilitiesWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final detail =
        Provider.of<HotelDetailApiProvider>(context).hotelDetailEntity;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 28.0),
          child: Subtitle(
            title: 'Facilities',
          ),
        ),
        ListView.separated(
            shrinkWrap: true,
            padding: const EdgeInsets.only(top: 8.0),
            physics: ClampingScrollPhysics(),
            itemCount: detail.facilities.length > 4
                ? detail.facilities.length + 1
                : detail.facilities.length,
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
              if (detail.facilities.length > 4) {
                if (index == detail.facilities.length) {
                  return InkResponse(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                          HotelDetailAllFacilitiesPage.routeName,
                          arguments: {
                            HotelDetailAllFacilitiesPage.facilities:
                                detail.facilities,
                          });
                    },
                    highlightColor: ThemeColors.primaryBlue,
                    child: Container(
                      color: ThemeColors.black0,
                      width: double.maxFinite,
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'See All Facilities',
                              style: ThemeText.sfMediumBody
                                  .copyWith(color: ThemeColors.primaryBlue),
                            ),
                            Icon(
                              Icons.keyboard_arrow_down,
                              color: ThemeColors.primaryBlue,
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return InkWell(
                    onTap: () {
                      //provider.selectFacility = index;
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
                            '${detail.facilities[index]}',
                            style: ThemeText.sfRegularBody,
                          ),
                          SvgPicture.asset('images/checkbox_checked_blue.svg'),
                        ],
                      ),
                    ),
                  );
                }
              } else {
                return InkWell(
                  onTap: () {
                    //provider.selectFacility = index;
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
                          '${detail.facilities[index]}',
                          style: ThemeText.sfRegularBody,
                        ),
                        SvgPicture.asset('images/checkbox_checked_blue.svg'),
                      ],
                    ),
                  ),
                );
              }
            }),
      ],
    );
  }
}
