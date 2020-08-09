import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:localin/components/filled_button_default.dart';
import 'package:localin/presentation/revamp_hotel/hotel_list_page/provider/hotel_list_provider.dart';
import 'package:localin/presentation/revamp_hotel/hotel_list_page/widgets/hotel_list_filter_price_indicator_column.dart';
import 'package:localin/presentation/revamp_hotel/hotel_list_page/widgets/hotel_list_filter_subtitle.dart';
import 'package:localin/presentation/shared_widgets/custom_category_radius.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

class HotelListFilterBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Provider.of<HotelListProvider>(context, listen: false)
            .panelController
            .animatePanelToPosition(0.0, duration: Duration(milliseconds: 250));
        return false;
      },
      child: Scaffold(
        backgroundColor: ThemeColors.black10,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: ThemeColors.black0,
          leading: InkResponse(
            onTap: () {
              Provider.of<HotelListProvider>(context, listen: false)
                  .panelController
                  .animatePanelToPosition(0.0,
                      duration: Duration(milliseconds: 250));
            },
            child: Icon(
              Icons.close,
              color: ThemeColors.black80,
            ),
          ),
          title: Text('Filters', style: ThemeText.sfMediumHeadline),
          actions: <Widget>[
            Container(
              alignment: FractionalOffset.centerRight,
              margin: const EdgeInsets.only(right: 20.0),
              child: Text(
                'Reset Filter',
                style: ThemeText.sfMediumHeadline
                    .copyWith(color: ThemeColors.primaryBlue),
              ),
            )
          ],
        ),
        bottomNavigationBar: FilledButtonDefault(
          radius: 0.0,
          onPressed: () {},
          buttonText: 'Apply Filter',
          textTheme: ThemeText.rodinaTitle3.copyWith(color: ThemeColors.black0),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              HotelListFilterSubtitle(
                title: 'Price Range',
              ),
              Container(
                color: ThemeColors.black0,
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 28.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                            child: HotelListFilterPriceIndicatorColumn(
                          title: 'Highest',
                        )),
                        SizedBox(width: 33.0),
                        Expanded(
                          child: HotelListFilterPriceIndicatorColumn(
                            title: 'Lowest',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    FlutterSlider(
                      values: [50000, 2000000],
                      handlerWidth: 25.0,
                      tooltip: FlutterSliderTooltip(disabled: true),
                      handlerHeight: 25.0,
                      minimumDistance: 10000,
                      rightHandler: FlutterSliderHandler(
                          foregroundDecoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: ThemeColors.primaryBlue,
                      )),
                      handler: FlutterSliderHandler(
                          foregroundDecoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: ThemeColors.primaryBlue,
                      )),
                      rangeSlider: true,
                      max: 2000000,
                      min: 0,
                      onDragging: (handlerIndex, lowerValue, upperValue) {},
                    )
                  ],
                ),
              ),
              HotelListFilterSubtitle(
                title: 'Ratings',
              ),
              Container(
                color: ThemeColors.black0,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 20.0),
                height: 60.0,
                child: ListView.builder(
                  itemCount: 5,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return CustomCategoryRadius(
                      height: 16.0,
                      radius: 100.0,
                      marginRight: 6.0,
                      verticalPadding: 8.0,
                      horizontalPadding: 20.0,
                      buttonBackgroundColor: ThemeColors.black10,
                      text: '$index star',
                      textTheme: ThemeText.sfRegularBody,
                    );
                  },
                ),
              ),
              HotelListFilterSubtitle(
                title: 'Facilities',
              ),
              Column(
                  children: List.generate(
                      20,
                      (index) => InkWell(
                            onTap: () {},
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16.0, horizontal: 20.0),
                              color: ThemeColors.black0,
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'text $index',
                                    style: ThemeText.sfRegularBody,
                                  ),
                                  SvgPicture.asset(
                                      'images/${true ? 'checkbox_checked_blue' : 'checkbox_uncheck'}.svg'),
                                ],
                              ),
                            ),
                          )))
            ],
          ),
        ),
      ),
    );
  }
}
