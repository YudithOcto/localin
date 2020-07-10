import 'package:flutter/material.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';

class RowTicketSelectionQuantityWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72.0,
      color: ThemeColors.black0,
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('IDR 89.000', style: ThemeText.sfSemiBoldHeadline),
              SizedBox(height: 4.0),
              Text(
                '/ticket',
                style: ThemeText.sfSemiBoldFootnote
                    .copyWith(color: ThemeColors.black60),
              )
            ],
          ),
          Row(
            children: <Widget>[
              Container(
                height: 40.0,
                width: 40.0,
                decoration: BoxDecoration(
                    color: ThemeColors.black10,
                    borderRadius: BorderRadius.circular(8.0)),
                child: Icon(
                  Icons.remove,
                  color: ThemeColors.black100,
                ),
              ),
              Container(
                height: 40.0,
                width: 52.0,
                alignment: FractionalOffset.center,
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                decoration: BoxDecoration(
                    border: Border.all(color: ThemeColors.black20),
                    borderRadius: BorderRadius.circular(8.0)),
                child: Text(
                  '3',
                  textAlign: TextAlign.center,
                  style: ThemeText.sfSemiBoldFootnote,
                ),
              ),
              Container(
                height: 40.0,
                width: 40.0,
                decoration: BoxDecoration(
                    color: ThemeColors.black10,
                    borderRadius: BorderRadius.circular(8.0)),
                child: Icon(
                  Icons.add,
                  color: ThemeColors.black100,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
