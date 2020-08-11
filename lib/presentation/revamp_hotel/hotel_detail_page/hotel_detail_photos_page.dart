import 'package:flutter/material.dart';
import 'package:localin/components/custom_image_radius.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';

class HotelDetailPhotosPage extends StatelessWidget {
  static const routeName = 'HotelDetailPhotosPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.black10,
      appBar: AppBar(
        backgroundColor: ThemeColors.black0,
        leading: Icon(Icons.arrow_back, color: ThemeColors.black80),
        titleSpacing: 0.0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '7 Photos',
              style: ThemeText.sfMediumHeadline,
            ),
            Text(
              'OYO Life 2736 Pondok Klara',
              style: ThemeText.sfMediumCaption,
            )
          ],
        ),
      ),
      body: Container(
        color: ThemeColors.black0,
        width: double.maxFinite,
        padding: EdgeInsets.all(16.0),
        margin: const EdgeInsets.only(top: 30.0),
        child: GridView.count(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          crossAxisCount: 3,
          childAspectRatio: 1.0,
          children: List.generate(
              6,
              (index) => Padding(
                    padding: const EdgeInsets.all(7.5),
                    child: CustomImageRadius(
                      height: 100.0,
                      width: 100.0,
                      radius: 12.0,
                    ),
                  )),
        ),
      ),
    );
  }
}
