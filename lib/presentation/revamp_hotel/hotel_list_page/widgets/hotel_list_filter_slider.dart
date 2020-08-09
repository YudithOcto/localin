import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:localin/presentation/revamp_hotel/hotel_list_page/provider/hotel_list_filter_provider.dart';
import 'package:localin/presentation/revamp_hotel/hotel_list_page/widgets/hotel_list_filter_price_indicator_column.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

class HotelLIstFilterSlider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: ThemeColors.black0,
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 28.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Consumer<HotelListFilterProvider>(
            builder: (_, provider, __) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                      child: HotelListFilterPriceIndicatorColumn(
                    title: 'Lowest',
                    value: provider.currentLowest,
                  )),
                  SizedBox(width: 33.0),
                  Expanded(
                    child: HotelListFilterPriceIndicatorColumn(
                      title: 'Highest',
                      value: provider.currentHighest,
                    ),
                  ),
                ],
              );
            },
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
            onDragging: (handlerIndex, lowerValue, upperValue) {
              final provider =
                  Provider.of<HotelListFilterProvider>(context, listen: false);
              provider.changeLowest = lowerValue;
              provider.changeHighest = upperValue;
            },
          )
        ],
      ),
    );
  }
}
