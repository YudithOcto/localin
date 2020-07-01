import 'package:flutter/material.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:localin/components/custom_app_bar.dart';
import 'package:localin/components/custom_dialog.dart';
import 'package:localin/components/custom_toast.dart';
import 'package:localin/components/filled_button_default.dart';
import 'package:localin/model/community/community_detail.dart';
import 'package:localin/presentation/community/community_event/community_create_event_page.dart';
import 'package:localin/presentation/community/community_event/community_event_detail_page.dart';
import 'package:localin/presentation/community/community_event/provider/community_create_event_provider.dart';
import 'package:localin/presentation/community/community_event/widgets/community_create_event_add_audience.dart';
import 'package:localin/presentation/community/community_event/widgets/community_create_event_location.dart';
import 'package:localin/presentation/community/community_event/widgets/community_create_event_online_widget.dart';
import 'package:localin/presentation/community/community_event/widgets/create_community_event_add_image.dart';
import 'package:localin/presentation/shared_widgets/input_form_with_subtitle_widget.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

class CommunityCreateEventWrapper extends StatefulWidget {
  @override
  _CommunityCreateEventWrapperState createState() =>
      _CommunityCreateEventWrapperState();
}

class _CommunityCreateEventWrapperState
    extends State<CommunityCreateEventWrapper> {
  @override
  void initState() {
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        if (!visible) {
          FocusScope.of(context).unfocus();
        }
      },
    );
    super.initState();
  }

  List<Widget> getButtonVerticalDialog(String eventId) {
    List<Widget> buttons = List();
    buttons.add(FilledButtonDefault(
      buttonText: 'View Event',
      textTheme: ThemeText.rodinaTitle3.copyWith(color: ThemeColors.black0),
      onPressed: () {
        final routeArgs =
            ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
        CommunityDetail detail =
            routeArgs[CommunityCreateEventPage.communityData];
        Navigator.of(context).pushNamedAndRemoveUntil(
            CommunityEventDetailPage.routeName, (Route<dynamic> route) => false,
            arguments: {
              CommunityEventDetailPage.eventSlug: eventId,
              CommunityEventDetailPage.communityData: detail,
              CommunityEventDetailPage.backToHome: true,
            });
      },
      backgroundColor: ThemeColors.primaryBlue,
    ));
    buttons.add(InkWell(
      onTap: () {
        Navigator.of(context).pop();
        Navigator.of(context).pop('success');
      },
      child: Container(
        alignment: FractionalOffset.center,
        margin: EdgeInsets.only(top: 10.0),
        child: Text(
          'Back to Community',
          style: ThemeText.rodinaTitle3.copyWith(color: ThemeColors.black80),
        ),
      ),
    ));
    return buttons;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        onClickBackButton: () => Navigator.of(context).pop(),
        pageTitle: 'Create Event',
        appBar: AppBar(),
      ),
      bottomNavigationBar: Consumer<CommunityCreateEventProvider>(
        builder: (context, provider, child) {
          return FilledButtonDefault(
            buttonText: 'Share',
            backgroundColor: provider.isShareButtonActive.isEmpty
                ? ThemeColors.primaryBlue
                : ThemeColors.black80,
            textTheme:
                ThemeText.rodinaTitle3.copyWith(color: ThemeColors.black0),
            onPressed: () async {
              if (provider.isShareButtonActive.isNotEmpty) {
                return CustomToast.showCustomBookmarkToast(
                    context, provider.isShareButtonActive);
              }
              CustomDialog.showLoadingDialog(context, message: 'Loading ...');
              final response = await provider.createEvent();
              CustomDialog.closeDialog(context);
              if (!response.error) {
                CustomDialog.showCustomDialogVerticalMultipleButton(context,
                    title: 'Event Created!',
                    message:
                        'You have successfully create your event. Share your event to your community.',
                    dialogButtons: getButtonVerticalDialog(response.data.id));
              } else {
                CustomDialog.showCustomDialogWithButton(
                    context, 'Event', '${response?.message}',
                    btnText: 'Close');
              }
            },
          );
        },
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 50.0),
        child: Consumer<CommunityCreateEventProvider>(
          builder: (context, provider, child) {
            return Column(
              children: <Widget>[
                CreateCommunityEventAddImage(),
                InputFormWithSubtitleWidget(
                  subtitle: 'EVENT NAME',
                  controller: provider.eventFormNameController,
                  maxInput: 200,
                ),
                InputFormWithSubtitleWidget(
                  subtitle: 'DESCRIPTION',
                  controller: provider.eventFormDescriptionController,
                  maxInput: 2200,
                ),
                InputFormWithSubtitleWidget(
                  subtitle: 'START DATE & TIME',
                  controller: provider.eventStartDateController,
                  onPressed: () async {
                    FocusScope.of(context).unfocus();
                    onPickedDateTime(context, true, initialDate: DateTime.now(),
                        onComplete: (DateTime date) {
                      provider.startEventDateTime(date);
                    });
                  },
                  isFormDisabled: true,
                ),
                InputFormWithSubtitleWidget(
                  subtitle: 'END DATE & TIME',
                  controller: provider.eventEndDateController,
                  onPressed: () {
                    if (provider.initialEndDate == null) {
                      CustomToast.showCustomBookmarkToast(
                          context, 'Please choose start date first',
                          duration: 1);
                      return;
                    }
                    FocusScope.of(context).unfocus();
                    onPickedDateTime(context, false,
                        initialDate: provider.initialEndDate,
                        onComplete: (DateTime date) {
                      provider.endEventDateTime(date);
                    });
                  },
                  isFormDisabled: true,
                ),
                CreateCommunityEventAddAudience(
                  controller: provider.eventFormAudienceController,
                  defaultAudienceNumber: ['10', '20', '40', '80'],
                  onTap: (v) {
                    FocusScope.of(context).unfocus();
                    provider.eventFormAudienceController.text = v;
                  },
                ),
                CommunityCreateEventOnlineWidget(
                  onChanged: (v) => provider.enabledOnlineEvent = v,
                  value: provider.isOnlineEvent,
                ),
                CommunityCreateEventLocation(),
              ],
            );
          },
        ),
      ),
    );
  }

  onPickedDateTime(BuildContext context, bool isStartDate,
      {Function(DateTime) onComplete, DateTime initialDate}) async {
    DateTime picked = await showDatePicker(
      context: context,
      firstDate: initialDate ?? DateTime.now().add(Duration(days: 1)),
      lastDate: DateTime(DateTime.now().year + 5),
      initialDate: initialDate ?? DateTime.now().add(Duration(days: 1)),
    );
    if (picked != null) {
      var timeOfDay = TimeOfDay(
          hour: TimeOfDay.now().hour + 1, minute: TimeOfDay.now().minute);
      if (!isStartDate) {
        timeOfDay =
            TimeOfDay(hour: initialDate.hour + 1, minute: initialDate.minute);
      }
      onPickedTime(
          onComplete: onComplete,
          picked: picked,
          selectedTime: timeOfDay,
          isStartDate: isStartDate,
          initialDate: initialDate);
    }
  }

  onPickedTime(
      {Function(DateTime) onComplete,
      DateTime picked,
      TimeOfDay selectedTime,
      bool isStartDate,
      DateTime initialDate}) async {
    TimeOfDay t = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (t != null) {
      final finalDate =
          DateTime(picked.year, picked.month, picked.day, t.hour, t.minute);
      if (isStartDate) {
        if (finalDate.isBefore(DateTime.now())) {
          CustomToast.showCustomBookmarkToast(
              context, 'You cannot set time before now',
              duration: 1);
        } else {
          onComplete(finalDate);
        }
      } else {
        if (finalDate.isBefore(initialDate)) {
          CustomToast.showCustomBookmarkToast(
              context, 'You cannot set time before now',
              duration: 1);
        } else {
          onComplete(finalDate);
        }
      }
    }
  }
}
