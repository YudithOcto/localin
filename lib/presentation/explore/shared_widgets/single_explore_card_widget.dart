import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localin/presentation/explore/detail_page/explore_detail_page.dart';
import 'package:localin/presentation/explore/shared_widgets/custom_category_radius.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';

class SingleExploreCardWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(ExploreDetailPage.routeName);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: 188.0,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                      image: AssetImage('images/create_article_image.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  height: 188.0,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color.fromRGBO(0, 0, 0, 0.4),
                        Color.fromRGBO(0, 0, 0, 0),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 18.0,
                  left: 12.0,
                  child: CustomCategoryRadius(
                    text: 'Attraction',
                    textTheme: ThemeText.sfSemiBoldFootnote,
                    verticalPadding: 6.0,
                    radius: 100.0,
                  ),
                ),
                Positioned(
                  top: 18.0,
                  right: 12.0,
                  child: SvgPicture.asset(
                    'images/bookmark_outline.svg',
                    color: ThemeColors.black0,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
              child: Text(
                'The Wave Pondok Indah WaterPark Tickets',
                style: ThemeText.rodinaTitle3,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                'Pondok Indah, Jakarta Selatan',
                style: ThemeText.sfMediumFootnote
                    .copyWith(color: ThemeColors.black80),
              ),
            ),
            Text(
              'IDR 59.500',
              style: ThemeText.rodinaTitle3.copyWith(color: ThemeColors.orange),
            )
          ],
        ),
      ),
    );
  }
}
