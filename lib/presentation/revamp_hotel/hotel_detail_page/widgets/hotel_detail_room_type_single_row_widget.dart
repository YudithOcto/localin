import 'package:flutter/material.dart';
import 'package:localin/components/custom_image_only_radius.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';

class HotelDetailRoomTypeSingleRowWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
      child: Container(
        color: ThemeColors.black0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CustomImageOnlyRadius(
              height: 188.0,
              imageUrl: 'www.google.com',
              width: double.maxFinite,
              placeHolderColor: ThemeColors.black60,
              topLeft: 8.0,
              topRight: 8.0,
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 12.0, bottom: 2.0, left: 15.0, right: 15.0),
              child: Text('OYO Life 2736 Pondok Klara',
                  style: ThemeText.rodinaTitle3),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(bottom: 2.0, left: 15.0, right: 15.0),
              child: Text(
                'Room Size : 150 sqft • 2 guest(s)/room • 1 queen bed • With Air Conditioning',
                style: ThemeText.sfMediumFootnote
                    .copyWith(color: ThemeColors.black80),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 8),
                  child: Text(
                    'Rp 250.000',
                    style: ThemeText.rodinaTitle3
                        .copyWith(color: ThemeColors.orange),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Text(
                    'Rp 416.000',
                    style: ThemeText.sfRegularBody.copyWith(
                        color: ThemeColors.black80,
                        decoration: TextDecoration.lineThrough),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: Text(
                    '/ per room per night',
                    style: ThemeText.sfMediumCaption
                        .copyWith(color: ThemeColors.brandBlack),
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 21.0, left: 15.0, right: 15.0),
              height: 48.0,
              padding:
                  const EdgeInsets.only(bottom: 2.0, left: 15.0, right: 15.0),
              alignment: FractionalOffset.center,
              decoration: BoxDecoration(
                color: ThemeColors.primaryBlue,
                borderRadius: BorderRadius.circular(4.0),
              ),
              width: double.maxFinite,
              child: Text('Select',
                  style: ThemeText.rodinaTitle3
                      .copyWith(color: ThemeColors.black0)),
            )
          ],
        ),
      ),
    );
  }
}
