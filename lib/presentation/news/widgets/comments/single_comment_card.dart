import 'package:flutter/material.dart';
import 'package:localin/components/circle_image.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:localin/utils/date_helper.dart';

class SingleCommentCard extends StatelessWidget {
  final int index;
  final Function onFunction;
  SingleCommentCard({this.index, this.onFunction});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 197,
      color: ThemeColors.black0,
      margin: const EdgeInsets.only(top: 10.0),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CircleImage(
            width: 40.0,
            height: 40.0,
          ),
          SizedBox(
            width: 11.0,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      'Gita Adi',
                      style: ThemeText.sfMediumBody
                          .copyWith(color: ThemeColors.brandBlack),
                    ),
                    SizedBox(
                      width: 7.0,
                    ),
                    Text(
                      '\u2022 ${DateHelper.timeAgo(DateTime.now().subtract(Duration(hours: 3)))}',
                      style: ThemeText.sfRegularFootnote
                          .copyWith(color: ThemeColors.black80),
                    )
                  ],
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  'Wouldn’t that be because that’s where the “+” button usually is? '
                  'I think it makes sense to point the user to where the main button lives,'
                  ' so that they know for sure next time.',
                  style: ThemeText.sfRegularBody
                      .copyWith(color: ThemeColors.brandBlack),
                ),
                SizedBox(
                  height: 13.0,
                ),
                DashedLine(
                  color: ThemeColors.black20,
                  height: 1.5,
                ),
                SizedBox(
                  height: 9.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      '14 Replies',
                      style: ThemeText.sfMediumBody
                          .copyWith(color: ThemeColors.primaryBlue),
                    ),
                    InkWell(
                      onTap: () {
                        onFunction();
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                      child: Text(
                        'Reply',
                        style: ThemeText.sfMediumBody
                            .copyWith(color: ThemeColors.brandBlack),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class DashedLine extends StatelessWidget {
  final double height;
  final double dashWidth;
  final Color color;
  const DashedLine(
      {this.height = 1, this.color = Colors.black, this.dashWidth = 5.0});
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      final boxWidth = constraints.constrainWidth();
      final dashHeight = height;
      final dashCount = (boxWidth / (2 * dashWidth)).floor();
      return Flex(
        children: List.generate(dashCount, (index) {
          return SizedBox(
            width: dashWidth,
            height: dashHeight,
            child: DecoratedBox(
              decoration: BoxDecoration(color: color),
            ),
          );
        }),
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        direction: Axis.horizontal,
      );
    });
  }
}
