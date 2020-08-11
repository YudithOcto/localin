import 'package:flutter/material.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:localin/utils/number_helper.dart';

class RowTicketSelectionQuantityWidget extends StatelessWidget {
  final int price;
  final String ticketType;
  final VoidCallback onAddPressed;
  final VoidCallback onSubtractPressed;
  final int quantityIndicator;

  RowTicketSelectionQuantityWidget(
      {this.price,
      this.ticketType,
      this.onAddPressed,
      this.onSubtractPressed,
      this.quantityIndicator});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ThemeColors.black0,
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('$ticketType', style: ThemeText.sfSemiBoldFootnote),
                SizedBox(height: 6.0),
                Text('${price == 0 ? 'Free' : getFormattedCurrency(price)}',
                    style: ThemeText.sfSemiBoldHeadline),
                SizedBox(height: 4.0),
                Text(
                  '/ticket',
                  style: ThemeText.sfSemiBoldFootnote
                      .copyWith(color: ThemeColors.black60),
                )
              ],
            ),
          ),
          Row(
            children: <Widget>[
              InkWell(
                onTap: onSubtractPressed,
                child: Container(
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
                  '$quantityIndicator',
                  textAlign: TextAlign.center,
                  style: ThemeText.sfSemiBoldFootnote,
                ),
              ),
              InkWell(
                onTap: onAddPressed,
                child: Container(
                  height: 40.0,
                  width: 40.0,
                  decoration: BoxDecoration(
                      color: ThemeColors.black10,
                      borderRadius: BorderRadius.circular(8.0)),
                  child: Icon(
                    Icons.add,
                    color: ThemeColors.black100,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
