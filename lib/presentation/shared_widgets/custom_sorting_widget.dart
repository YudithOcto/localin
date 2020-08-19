import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';

class CustomSortingWidget extends StatelessWidget {
  final List<String> sortingTitle;
  final Function(String) onTap;
  final int currentSelectedSort;

  CustomSortingWidget(
      {@required this.sortingTitle,
      @required this.currentSelectedSort,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      decoration: BoxDecoration(
          color: ThemeColors.black0,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12.0),
            topRight: Radius.circular(12.0),
          )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 20.0, bottom: 28.0),
            child: Text('Sort',
                style: ThemeText.sfSemiBoldHeadline
                    .copyWith(color: ThemeColors.black80)),
          ),
          Expanded(
            child: ListView.separated(
              separatorBuilder: (context, index) {
                return Divider();
              },
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemCount: sortingTitle.length,
              itemBuilder: (context, index) {
                return InkResponse(
                  onTap: () => onTap(sortingTitle[index]),
                  highlightColor: ThemeColors.primaryBlue,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          child: Text(sortingTitle[index],
                              style: ThemeText.sfRegularBody),
                        ),
                        SvgPicture.asset(
                            'images/${index == currentSelectedSort ? 'checkbox_checked_blue' : 'checkbox_uncheck'}.svg')
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          InkWell(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              height: 48.0,
              width: double.maxFinite,
              alignment: FractionalOffset.center,
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              decoration: BoxDecoration(
                color: ThemeColors.primaryBlue,
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Text(
                'Close',
                style:
                    ThemeText.rodinaTitle3.copyWith(color: ThemeColors.black0),
              ),
            ),
          )
        ],
      ),
    );
  }
}
