import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localin/presentation/shared_widgets/subtitle.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';

class HotelDetailAllFacilitiesPage extends StatelessWidget {
  static const routeName = 'HotelDetailAllFacilitiesPage';
  static const facilities = 'Facilities';

  @override
  Widget build(BuildContext context) {
    final routes =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    List<String> data = routes[facilities];
    return Scaffold(
      backgroundColor: ThemeColors.black10,
      appBar: AppBar(
        backgroundColor: ThemeColors.black0,
        elevation: 0.0,
        leading: InkResponse(
            onTap: () => Navigator.of(context).pop(),
            child: Icon(Icons.close, color: ThemeColors.black80)),
        titleSpacing: 0.0,
        title: Text(
          'All Facilities in this Hotel',
          style:
              ThemeText.sfMediumHeadline.copyWith(color: ThemeColors.black80),
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
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
              itemCount: data.length,
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
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 20.0),
                    color: ThemeColors.black0,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          '${data[index]}',
                          style: ThemeText.sfRegularBody,
                        ),
                        SvgPicture.asset('images/checkbox_checked_blue.svg'),
                      ],
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }
}
