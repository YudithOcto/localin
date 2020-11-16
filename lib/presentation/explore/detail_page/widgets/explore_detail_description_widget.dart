import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:html/parser.dart' as parser;
import 'package:localin/presentation/explore/detail_page/provider/explore_event_detail_provider.dart';
import 'package:localin/presentation/shared_widgets/custom_category_radius.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

class ExploreDetailDescriptionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ExploreEventDetailProvider>(context);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Visibility(
            visible: provider.eventDetail.category.isNotEmpty &&
                provider.eventDetail.category.first.categoryName != '-',
            child: CustomCategoryRadius(
              width: 80,
              height: 28.0,
              radius: 100.0,
              marginTop: 16.0,
              buttonBackgroundColor: ThemeColors.blue10,
              text:
                  '${provider.eventDetail.category.isNotEmpty ? provider.eventDetail.category.first.categoryName : '-'}',
              textTheme: ThemeText.sfSemiBoldFootnote
                  .copyWith(color: ThemeColors.blue60),
            ),
          ),
          SizedBox(height: 8.0),
          Text('${provider.eventDetail.eventName}',
              style: ThemeText.rodinaTitle2),
          SizedBox(height: 4.58),
          Visibility(
            visible: provider.eventLocation.isNotEmpty,
            child: Row(
              children: <Widget>[
                SvgPicture.asset(
                  'images/location.svg',
                  width: 13,
                  height: 16,
                ),
                SizedBox(width: 7.33),
                Expanded(
                  child: Text(
                    '${provider.eventLocation}',
                    style: ThemeText.sfRegularBody
                        .copyWith(color: ThemeColors.black80),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 25.67),
          Text(
            'What You’ll Experience',
            style: ThemeText.sfSemiBoldHeadline,
          ),
          SizedBox(height: 8.0),
          Text(
            '${parseHtml(provider.eventDetail?.description)}',
            style: ThemeText.sfRegularBody,
          )
        ],
      ),
    );
  }

  parseHtml(String data) {
    final doc = parser.parse(data);
    return parser.parse(doc.body.text).documentElement.text;
  }
}
