import 'package:flutter/material.dart';
import 'package:localin/presentation/revamp_hotel/hotel_list_page/provider/hotel_list_search_provider.dart';
import 'package:localin/presentation/revamp_hotel/hotel_list_page/widgets/single_column_bottom_sheet_search_widget.dart';
import 'package:provider/provider.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';

import 'hotel_bottom_sheet_choose_checkout_widget.dart';

GlobalKey<ScrollSnapListState> sslKey = GlobalKey();

class HotelBottomSheetDurationStayBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<HotelListSearchProvider>(
      builder: (_, provider, __) {
        return Flexible(
          flex: 2,
          child: InkWell(
            onTap: () async {
              final result = await showModalBottomSheet(
                  context: context,
                  builder: (_) {
                    return HotelBottomSheetChooseCheckoutWidget(
                      text: provider.getListCheckOutDate(),
                      currentIndex: provider.totalNightSelected,
                    );
                  });
              if (result != null) {
                provider.checkOutDate = result;
              }
            },
            child: SingleColumnBottomSheetSearchWidget(
              title: 'DURATION',
              value: '${provider.totalNightSelected} Night(s)',
            ),
          ),
        );
      },
    );
  }
}
