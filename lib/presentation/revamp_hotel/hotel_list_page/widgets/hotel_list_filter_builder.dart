import 'package:flutter/material.dart';
import 'package:localin/components/filled_button_default.dart';
import 'package:localin/presentation/revamp_hotel/hotel_list_page/provider/hotel_list_filter_provider.dart';
import 'package:localin/presentation/revamp_hotel/hotel_list_page/provider/hotel_list_provider.dart';
import 'package:localin/presentation/revamp_hotel/hotel_list_page/widgets/hotel_list_filter_slider.dart';
import 'package:localin/presentation/revamp_hotel/hotel_list_page/widgets/hotel_list_filter_subtitle.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

import 'hotel_list_filter_facilities.dart';

class HotelListFilterBuilder extends StatefulWidget {
  @override
  _HotelListFilterBuilderState createState() => _HotelListFilterBuilderState();
}

class _HotelListFilterBuilderState extends State<HotelListFilterBuilder> {
  bool _isInit = true;
  final _scrollController = ScrollController();

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<HotelListFilterProvider>(context).getFacility();
      _scrollController
        ..addListener(() {
          if (_scrollController.offset >=
              _scrollController.position.maxScrollExtent) {
            Provider.of<HotelListFilterProvider>(context)
                .getFacility(isRefresh: false);
          }
        });
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (Provider.of<HotelListProvider>(context, listen: false)
            .panelController
            .isPanelOpen) {
          Provider.of<HotelListProvider>(context, listen: false)
              .panelController
              .animatePanelToPosition(0.0,
                  duration: Duration(milliseconds: 250));
        } else {
          Navigator.of(context).pop();
        }

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
            Consumer<HotelListFilterProvider>(
              builder: (_, provider, __) {
                return InkResponse(
                  highlightColor: ThemeColors.primaryBlue,
                  onTap: () => provider.resetFilter(),
                  child: Container(
                    alignment: FractionalOffset.centerRight,
                    margin: const EdgeInsets.only(right: 20.0),
                    child: Text(
                      'Reset Filter',
                      style: ThemeText.sfMediumHeadline
                          .copyWith(color: ThemeColors.primaryBlue),
                    ),
                  ),
                );
              },
            )
          ],
        ),
        bottomNavigationBar: FilledButtonDefault(
          radius: 0.0,
          onPressed: () {
            final provider =
                Provider.of<HotelListProvider>(context, listen: false);
            provider.panelController.animatePanelToPosition(0.0,
                duration: Duration(milliseconds: 250));
            provider.revampHotelDataRequest =
                Provider.of<HotelListFilterProvider>(context).request;
            provider.getRestaurantList();
            Provider.of<HotelListProvider>(context, listen: false)
                .panelController
                .animatePanelToPosition(0.0,
                    duration: Duration(milliseconds: 250));
          },
          buttonText: 'Apply Filter',
          textTheme: ThemeText.rodinaTitle3.copyWith(color: ThemeColors.black0),
        ),
        body: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              HotelListFilterSubtitle(title: 'Price Range'),
              HotelLIstFilterSlider(),
              HotelListFilterSubtitle(title: 'Facilities'),
              HotelListFilterFacilities(),
            ],
          ),
        ),
      ),
    );
  }
}
