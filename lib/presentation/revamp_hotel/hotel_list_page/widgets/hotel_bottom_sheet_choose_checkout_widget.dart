import 'package:flutter/material.dart';
import 'package:localin/components/filled_button_default.dart';
import 'package:localin/components/outline_button_default.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';

import 'hotel_bottom_sheet_duration_stay_widget.dart';

class HotelBottomSheetChooseCheckoutWidget extends StatefulWidget {
  final List<String> text;
  HotelBottomSheetChooseCheckoutWidget({this.text});
  @override
  _HotelBottomSheetChooseCheckoutWidgetState createState() =>
      _HotelBottomSheetChooseCheckoutWidgetState();
}

class _HotelBottomSheetChooseCheckoutWidgetState
    extends State<HotelBottomSheetChooseCheckoutWidget> {
  int currentIndex = 1;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 27.0),
      decoration: BoxDecoration(
          color: ThemeColors.black0,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(8.0),
            topLeft: Radius.circular(8.0),
          )),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Choose Duration of Stay',
            style: ThemeText.sfSemiBoldHeadline
                .copyWith(color: ThemeColors.black80),
          ),
          SizedBox(height: 12.0),
          Container(
            height: 156.0,
            child: ScrollSnapList(
              scrollDirection: Axis.vertical,
              itemSize: 56,
              initialIndex: 1,
              key: sslKey,
              focusOnItemTap: true,
              onItemFocus: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              itemCount: widget.text.length,
              itemBuilder: (context, index) {
                return InkResponse(
                  onTap: () {
                    Navigator.of(context).pop(widget.text[index]);
                  },
                  highlightColor: ThemeColors.primaryBlue,
                  child: Container(
                    height: 56.0,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          '${index + 1} night(s)',
                          style: ThemeText.sfMediumHeadline.copyWith(
                              color: currentIndex == index
                                  ? ThemeColors.primaryBlue
                                  : ThemeColors.primaryBlue.withOpacity(0.3)),
                        ),
                        Text(
                          widget.text[index],
                          style: ThemeText.sfRegularBody.copyWith(
                              color: currentIndex == index
                                  ? ThemeColors.primaryBlue
                                  : ThemeColors.primaryBlue.withOpacity(0.3)),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 30.0, bottom: 16.0),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: OutlineButtonDefault(
                  onPressed: () => Navigator.of(context).pop(),
                  buttonText: 'Cancel',
                )),
                SizedBox(width: 17.0),
                Expanded(
                  child: FilledButtonDefault(
                    onPressed: () =>
                        Navigator.of(context).pop(widget.text[currentIndex]),
                    buttonText: 'Select',
                    textTheme: ThemeText.rodinaTitle3
                        .copyWith(color: ThemeColors.black0),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
