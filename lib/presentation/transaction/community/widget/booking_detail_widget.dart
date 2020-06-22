import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localin/model/transaction/transaction_response_model.dart';
import 'package:localin/presentation/news/widgets/comments/parent_comment_card.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:localin/utils/countdown.dart';
import 'package:localin/utils/number_helper.dart';

class BookingDetailWidget extends StatefulWidget {
  final TransactionCommunityDetail detail;
  final bool showPaymentRow;
  BookingDetailWidget({@required this.detail, this.showPaymentRow = false});
  @override
  _BookingDetailWidgetState createState() => _BookingDetailWidgetState();
}

class _BookingDetailWidgetState extends State<BookingDetailWidget> {
  Countdown _countdown;

  startCountDown() {
    if (widget.showPaymentRow) {
      _countdown =
          Countdown(expiredTime: DateTime.parse(widget.detail.expiredAt));
      _countdown.run();
    }
  }

  @override
  void initState() {
    startCountDown();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      color: ThemeColors.black0,
      margin: EdgeInsets.only(top: 4.0),
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Text(
                  'BOOKING ID: ${widget.detail.transactionId}',
                  overflow: TextOverflow.ellipsis,
                  style: ThemeText.sfMediumFootnote
                      .copyWith(color: ThemeColors.black80),
                ),
              ),
              Text(
                '${getFormattedCurrency(widget.detail.totalPayment)}',
                style: ThemeText.sfSemiBoldFootnote
                    .copyWith(color: ThemeColors.green),
              )
            ],
          ),
          SizedBox(height: 8.0),
          Text(
            '${widget.detail.description}',
            style: ThemeText.rodinaHeadline,
          ),
          SizedBox(
            height: 16.0,
          ),
          Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 15.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: ThemeColors.black10,
            ),
            child: Row(
              children: <Widget>[
                SvgPicture.asset('images/community_pro_icon.svg'),
                SizedBox(width: 12.0),
                Text(
                  'Komunitas Pro (Bulanan)',
                  style: ThemeText.sfMediumFootnote,
                )
              ],
            ),
          ),
          widget.showPaymentRow
              ? Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0, bottom: 8.0),
                      child: DashedLine(
                        color: ThemeColors.black20,
                        height: 1.5,
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        SvgPicture.asset('images/community_pro_time_icon.svg'),
                        SizedBox(
                          width: 5.0,
                        ),
                        StreamBuilder<String>(
                          stream: _countdown.differenceStream,
                          builder: (context, snapshot) {
                            return Text(
                              'Waiting for payment \u2022 ${snapshot.data ?? '00:00'}',
                              style: ThemeText.sfMediumFootnote
                                  .copyWith(color: ThemeColors.orange),
                            );
                          },
                        ),
                      ],
                    )
                  ],
                )
              : Container(),
        ],
      ),
    );
  }
}
