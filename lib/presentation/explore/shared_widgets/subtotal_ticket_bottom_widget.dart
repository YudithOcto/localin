import 'package:flutter/material.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';

class SubtotalTicketButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final String totalTicketPrice;
  final int totalSelectedTicket;
  SubtotalTicketButtonWidget(
      {this.onPressed, this.totalSelectedTicket, this.totalTicketPrice});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72.0,
      color: ThemeColors.black0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '$totalTicketPrice',
                  style: ThemeText.sfSemiBoldHeadline
                      .copyWith(color: ThemeColors.orange),
                ),
                SizedBox(height: 4.0),
                Text(
                  '$totalSelectedTicket tickets',
                  style: ThemeText.sfSemiBoldFootnote
                      .copyWith(color: ThemeColors.black60),
                )
              ],
            ),
            InkWell(
              onTap: onPressed,
              child: Container(
                decoration: BoxDecoration(
                  color: ThemeColors.primaryBlue,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 20.0),
                  child: Text(
                    'Continue',
                    style: ThemeText.rodinaTitle3
                        .copyWith(color: ThemeColors.black0),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
