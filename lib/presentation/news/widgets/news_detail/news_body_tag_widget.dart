import 'package:flutter/material.dart';
import 'package:localin/model/article/tag_model_model.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';

class NewsBodyTagWidget extends StatelessWidget {
  final List<TagModel> tagModel;
  NewsBodyTagWidget({this.tagModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30.0,
      child: ListView(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          children: List.generate(tagModel?.length ?? 0, (index) {
            return Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 4.0),
              margin: EdgeInsets.only(left: index == 0 ? 0.0 : 9.0),
              decoration: BoxDecoration(
                color: ThemeColors.primaryBlue,
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Text(
                '#${tagModel[index]?.tagName ?? ''}',
                style:
                    ThemeText.sfMediumBody.copyWith(color: ThemeColors.black0),
              ),
            );
          })),
    );
  }
}
