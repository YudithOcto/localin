import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localin/model/explore/explore_event_submission_details.dart';
import 'package:localin/presentation/explore/submit_form/widgets/title_grey_section.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';

class ConfirmationBookingDetail extends StatelessWidget {
  final ExploreEventSubmissionDetails detail;

  ConfirmationBookingDetail({this.detail});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleGreySection(title: 'Booking Detail'),
        Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 3.0),
          child: Text('TICKET: ',
              style: ThemeText.sfMediumFootnote
                  .copyWith(color: ThemeColors.black80)),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 8.0),
          child: Text(
            detail?.eventName ?? '',
            style: ThemeText.sfMediumTitle3,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Container(
            padding: const EdgeInsets.all(14.0),
            margin: const EdgeInsets.only(bottom: 20.0),
            decoration: BoxDecoration(
                color: ThemeColors.black10,
                borderRadius: BorderRadius.circular(8.0)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    flex: 1,
                    child: Text(
                      'Date',
                      style: ThemeText.sfSemiBoldFootnote,
                    )),
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      SvgPicture.asset('images/calendar.svg'),
                      SizedBox(width: 10.0),
                      Flexible(
                        child: Text(detail?.eventDate,
                            style: ThemeText.sfMediumFootnote),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
