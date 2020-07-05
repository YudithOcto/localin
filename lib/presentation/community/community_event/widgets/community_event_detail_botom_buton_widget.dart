import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/material.dart';
import 'package:localin/components/custom_dialog.dart';
import 'package:localin/components/filled_button_default.dart';
import 'package:localin/model/community/community_event_response_model.dart';
import 'package:localin/presentation/community/community_event/provider/community_event_detail_provider.dart';
import 'package:localin/provider/auth_provider.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

class CommunityEventDetailBottomButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CommunityEventDetailProvider>(
      builder: (context, provider, child) {
        return Visibility(
          visible: provider.eventResponse.createdBy !=
              Provider.of<AuthProvider>(context, listen: false).userModel.id,
          child: InkWell(
            onTap: () async {
              if (isPastEvent(provider.eventResponse.endDate,
                  provider.eventResponse.userAttendStatus)) {
                return;
              }
              if (provider.eventResponse.userAttendStatus.eventButtonAction
                  .contains('Join this Event')) {
                CustomDialog.showLoadingDialog(context,
                    message: 'Please wait . . .');
                final result = await provider.updateJoinEvent(status: 'going');
                CustomDialog.closeDialog(context);
                showDescriptiveDialog(context, result?.message, result.data);
                provider.getEventDetail();
              } else {
                showRsvpDialog(context);
              }
            },
            child: Container(
              color: ThemeColors.black0,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 27.0),
                child: Container(
                  height: 47.35,
                  alignment: FractionalOffset.center,
                  decoration: BoxDecoration(
                      color: isPastEvent(provider.eventResponse.endDate,
                              provider.eventResponse.userAttendStatus)
                          ? ThemeColors.black80
                          : ThemeColors.primaryBlue,
                      borderRadius: BorderRadius.circular(4.0)),
                  child: Text(
                    '${isPastEvent(provider.eventResponse.endDate, provider.eventResponse.userAttendStatus) ? 'Past Event' : provider.eventResponse.userAttendStatus.eventButtonAction}',
                    textAlign: TextAlign.center,
                    style: ThemeText.rodinaTitle3
                        .copyWith(color: ThemeColors.black0),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  bool isPastEvent(DateTime endDate, String eventStatus) {
    if (endDate != null && eventStatus != null) {
      if (DateTime.now().isAfter(endDate) || eventStatus.contains('canceled')) {
        return true;
      }
    }
    return false;
  }

  Widget rsvpWidget(
    BuildContext context,
  ) {
    final provider =
        Provider.of<CommunityEventDetailProvider>(context, listen: false);
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          provider.sortingList.length,
          (index) {
            return InkWell(
              onTap: () async {
                Navigator.of(context).pop();
                CustomDialog.showLoadingDialog(context, message: 'Please Wait');
                provider.selectSort = provider.sortingList[index];
                final result = await provider.updateJoinEvent(
                    status: provider.selectedSort);
                CustomDialog.closeDialog(context);
                CustomDialog.showCustomDialogWithButton(
                    context, 'RSVP', result?.message,
                    btnText: 'Close');
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '${provider.sortingList[index]}',
                    style: ThemeText.sfMediumHeadline,
                  ),
                  Radio(
                    value: provider.sortingList[index],
                    activeColor: ThemeColors.black80,
                    groupValue: provider.selectedSort,
                    onChanged: (category) async {
                      Navigator.of(context).pop();
                      CustomDialog.showLoadingDialog(context,
                          message: 'Please Wait');
                      provider.selectSort = provider.sortingList[index];
                      final result = await provider.updateJoinEvent(
                          status: provider.selectedSort);
                      CustomDialog.closeDialog(context);
                      CustomDialog.showCustomDialogWithButton(
                          context, 'RSVP', result?.message,
                          btnText: 'Close');
                      provider.getEventDetail();
                    },
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  showRsvpDialog(BuildContext context) {
    showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        transitionDuration: const Duration(milliseconds: 150),
        barrierColor: ThemeColors.brandBlack.withOpacity(0.8),
        pageBuilder: (ctx, anim1, anim2) => rsvpWidget(context));
  }

  showDescriptiveDialog(
      BuildContext context, String joinResult, EventResponseData event) {
    String success = 'You’re going to this event!';
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                joinResult.contains('Success join event')
                    ? Text(
                        success,
                        textAlign: TextAlign.center,
                        style: ThemeText.sfMediumTitle3,
                      )
                    : RichText(
                        text: TextSpan(children: <TextSpan>[
                          TextSpan(
                            text:
                                'We are sorry, the quota has exceeded the limit, but ',
                            style: ThemeText.sfMediumTitle3,
                          ),
                          TextSpan(
                              text: 'You’re on waiting list ',
                              style: ThemeText.sfMediumTitle3
                                  .copyWith(color: ThemeColors.primaryBlue)),
                          TextSpan(
                              text: 'in this event!',
                              style: ThemeText.sfMediumTitle3),
                        ]),
                      ),
                SizedBox(
                  height: 18.0,
                ),
                Text(
                  'If anything changes, just update your RSVP. It helps hosts prepare.',
                  textAlign: TextAlign.center,
                  style: ThemeText.sfRegularBody
                      .copyWith(color: ThemeColors.black80),
                ),
                SizedBox(
                  height: 24.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: buttonWidget(context, event),
                )
              ],
            ),
          );
        });
  }

  List<Widget> buttonWidget(BuildContext context, EventResponseData data) {
    List<Widget> widget = List();
    widget.add(FilledButtonDefault(
      onPressed: () async {
        final Event event = Event(
          title: data.title,
          description: data?.description,
          location: '${data?.address ?? ''}',
          startDate: data.startDate,
          endDate: data.endDate,
        );
        Add2Calendar.addEvent2Cal(event);
      },
      textTheme: ThemeText.rodinaTitle3.copyWith(color: ThemeColors.black0),
      buttonText: 'Add to Calendar',
    ));
    widget.add(InkWell(
      onTap: () => Navigator.of(context).pop(),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Text(
          'Close',
          textAlign: TextAlign.center,
          style: ThemeText.rodinaTitle3.copyWith(color: ThemeColors.black80),
        ),
      ),
    ));
    return widget;
  }
}

extension on String {
  String get eventButtonAction {
    if (this == null) return '';
    if (this.toLowerCase().contains('canceled')) {
      return 'Past Event';
    } else if (this.toLowerCase().contains('have not joined'.toLowerCase())) {
      return 'Join this Event';
    } else {
      return 'Edit RSVP';
    }
  }
}
