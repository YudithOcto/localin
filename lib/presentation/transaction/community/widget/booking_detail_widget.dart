import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localin/model/transaction/transaction_response_model.dart';
import 'package:localin/presentation/news/widgets/comments/parent_comment_card.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:localin/utils/constants.dart';
import 'package:localin/utils/countdown.dart';
import 'package:localin/utils/date_helper.dart';
import 'package:localin/utils/number_helper.dart';

class BookingDetailWidget extends StatefulWidget {
  final TransactionDetailModel detail;
  final bool showPaymentRow;

  BookingDetailWidget({@required this.detail, this.showPaymentRow = false});

  @override
  _BookingDetailWidgetState createState() => _BookingDetailWidgetState();
}

class _BookingDetailWidgetState extends State<BookingDetailWidget> {
  Countdown _countdown;

  startCountDown() {
    if (widget.showPaymentRow &&
        widget.detail.status == kTransactionWaitingPayment) {
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
                  'BOOKING ID: ${widget.detail.bookingID}',
                  style: ThemeText.sfMediumFootnote
                      .copyWith(color: ThemeColors.black80),
                ),
              ),
              Text(
                '${widget.detail.totalPayment?.transformTicketPrice}',
                style: ThemeText.sfSemiBoldFootnote
                    .copyWith(color: ThemeColors.green),
              )
            ],
          ),
          SizedBox(height: 8.0),
          Text(
            '${widget.detail?.serviceDetail?.title}',
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
                SvgPicture.asset(
                    'images/${widget.detail.modul == 'komunitas' ? 'community_pro_icon' : 'calendar'}.svg'),
                SizedBox(width: 12.0),
                Expanded(
                  child: Text(
                    '$contentMessage',
                    style: ThemeText.sfMediumFootnote,
                  ),
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
                    widget.detail.status == kTransactionWaitingPayment
                        ? StreamBuilder<String>(
                            stream: _countdown.differenceStream,
                            builder: (context, snapshot) {
                              return Row(
                                children: <Widget>[
                                  SvgPicture.asset(
                                    'images/${snapshot.data == null ? kTransactionCancelled.svgIcon : widget.detail.status.svgIcon}.svg',
                                    width: 20.0,
                                    height: 20.0,
                                  ),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  Expanded(
                                    child: Text(
                                      '${snapshot.data == null ? kTransactionCancelled : '${widget.detail.status} \u2022'} ${snapshot.data ?? ''}',
                                      style: ThemeText.sfMediumFootnote
                                          .copyWith(
                                              color: snapshot.data == null
                                                  ? kTransactionCancelled
                                                      .rowColor
                                                  : widget
                                                      .detail.status.rowColor),
                                    ),
                                  ),
                                ],
                              );
                            },
                          )
                        : Row(
                            children: <Widget>[
                              SvgPicture.asset(
                                'images/${widget.detail.status.svgIcon}.svg',
                                width: 20.0,
                                height: 20.0,
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              Text(
                                '${widget.detail.status}',
                                style: ThemeText.sfMediumFootnote.copyWith(
                                    color: widget.detail.status.rowColor),
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

  String get contentMessage {
    if (widget.detail.modul == 'komunitas') {
      return 'Komunitas Pro (Bulanan)';
    } else if (widget.detail.modul == 'loket') {
      return '${formatTime(widget?.detail?.serviceDetail?.startDate)} - '
          '${formatTime(widget?.detail?.serviceDetail?.endDate)} \u2022 ${widget?.detail?.serviceDetail?.quantity} visitor(s)';
    } else if (widget.detail.modul == 'stay') {
      return '${formatTime(widget.detail.serviceDetail.checkIn)} • ${widget.detail.serviceDetail.night} night(s)';
    } else {
      return '';
    }
  }

  String formatTime(DateTime datetime) {
    return DateHelper.formatDate(date: datetime, format: 'EEE, dd MMMM yyyy');
  }
}

extension on String {
  Color get rowColor {
    if (this.contains('Waiting for payment')) {
      return ThemeColors.orange;
    } else if (this.contains('Canceled')) {
      return ThemeColors.red;
    } else if (this.contains('Finished')) {
      return ThemeColors.green;
    } else {
      return ThemeColors.primaryBlue;
    }
  }

  String get svgIcon {
    if (this.contains('Waiting for payment')) {
      return 'community_pro_time_icon';
    } else if (this.contains('Canceled')) {
      return 'canceled';
    } else if (this.contains('Finished')) {
      return 'circle_checked_green';
    } else {
      return 'circle_checked_blue';
    }
  }
}

extension on int {
  String get transformTicketPrice {
    if (this == null || this == 0) return 'Free';
    return getFormattedCurrency(this);
  }
}

extension on TransactionDetailModel {
  String get bookingID {
    if (this.modul == 'komunitas' || this.modul == 'loket') {
      return this.transactionId;
    } else {
      return this.serviceDetail.bookingCode;
    }
  }
}
