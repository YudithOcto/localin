import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';

class BottomSortRestaurantWidget extends StatelessWidget {
  final List<String> sortingList = [
    'Highest Popularity',
    'Nearest to Me',
    'Most Far From Me',
    'Lowest Price',
    'Highest Price',
  ];
  final Function(int) onPressed;
  final int currentSelectedIndex;

  BottomSortRestaurantWidget({this.onPressed, this.currentSelectedIndex});

  Future showBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(12.0),
        topRight: Radius.circular(12.0),
      )),
      builder: (BuildContext context) {
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
                  itemCount: sortingList.length,
                  itemBuilder: (context, index) {
                    return InkResponse(
                      onTap: () => onPressed(index),
                      highlightColor: ThemeColors.primaryBlue,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              child: Text(sortingList[index],
                                  style: ThemeText.sfRegularBody),
                            ),
                            SvgPicture.asset(
                                'images/${index == currentSelectedIndex ? 'checkbox_checked_blue' : 'checkbox_uncheck'}.svg')
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
                    style: ThemeText.rodinaTitle3
                        .copyWith(color: ThemeColors.black0),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showBottomSheet(context);
      },
      child: Container(
        alignment: FractionalOffset.center,
        padding: const EdgeInsets.all(18.0),
        decoration: BoxDecoration(
            boxShadow: [BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.4))],
            color: ThemeColors.black0,
            borderRadius: BorderRadius.circular(4.0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset('images/sort_icon.svg'),
            SizedBox(width: 10.0),
            Text('SORT', style: ThemeText.sfSemiBoldBody),
          ],
        ),
      ),
    );
  }
}
