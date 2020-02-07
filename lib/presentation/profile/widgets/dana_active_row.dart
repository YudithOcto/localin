import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:localin/model/dana/dana_user_account_response.dart';
import 'package:localin/presentation/profile/profile_page.dart';
import 'package:localin/presentation/webview/webview_page.dart';

import '../../../themes.dart';

class DanaActiveRow extends StatelessWidget {
  final DanaAccountDetail detail;
  final Function(bool) isNeedRefresh;

  DanaActiveRow({this.detail, this.isNeedRefresh});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Image.asset(
                'images/dana_logo.png',
                scale: 7.0,
              ),
              SizedBox(
                height: 5.0,
              ),
              Text(
                'Saldo',
                style: kTitleStyle,
              )
            ],
          ),
          SizedBox(
            width: 10.0,
          ),
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: Themes.primaryBlue),
                borderRadius: BorderRadius.circular(10.0)),
            child: InkWell(
              onTap: () async {
                final result = await Navigator.of(context).pushNamed(
                    WebViewPage.routeName,
                    arguments: {WebViewPage.urlName: detail.urlTopUp});
                if (result != null) {
                  isNeedRefresh(true);
                }
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 2.0),
                child: Text(
                  'Top Up',
                  style: kValueStyle.copyWith(
                      color: Themes.primaryBlue,
                      letterSpacing: -.5,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  '${detail?.maskDanaId}',
                  style: kValueStyle,
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  '${getFormattedCurrency(detail?.balance)}',
                  style: kValueStyle.copyWith(color: Themes.primaryBlue),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  String getFormattedCurrency(int value) {
    if (value == null) return '';
    if (value == 0) return 'IDR 0';
    final formatter = NumberFormat('#,##0', 'en_US');
    return 'IDR ${formatter.format(value)}';
  }
}
