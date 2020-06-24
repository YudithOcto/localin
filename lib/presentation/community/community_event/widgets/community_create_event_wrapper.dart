import 'package:flutter/material.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:localin/components/custom_app_bar.dart';
import 'package:localin/components/custom_dialog.dart';
import 'package:localin/components/filled_button_default.dart';
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

  List<Widget> getButtonVerticalDialog() {
    List<Widget> buttons = List();
    buttons.add(FilledButtonDefault(
      buttonText: 'View Event',
      textTheme: ThemeText.rodinaTitle3.copyWith(color: ThemeColors.black0),
      onPressed: () {},
      backgroundColor: ThemeColors.primaryBlue,
    ));
    buttons.add(InkWell(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
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
              CustomDialog.showLoadingDialog(context, message: 'Loading ...');
              final response = await provider.createEvent();
              CustomDialog.closeDialog(context);
              if (!response.error) {
              } else {
                CustomDialog.showCustomDialogVerticalMultipleButton(context,
                    title: 'Event Created!',
                    message:
                        'You have successfully create your event. Share your event to your community.',
                    dialogButtons: getButtonVerticalDialog());
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
                ),
                InputFormWithSubtitleWidget(
                  subtitle: 'DESCRIPTION',
                  controller: provider.eventFormDescriptionController,
                ),
                InputFormWithSubtitleWidget(
                  subtitle: 'START DATE & TIME',
                  controller: provider.eventStartDateController,
                  onPressed: () async {
                    onPickedDateTime(context, initialDate: DateTime.now(),
                        onComplete: (DateTime date, TimeOfDay time) {
                      provider.startEventDateTime(date, time);
                    });
                  },
                  isFormDisabled: true,
                ),
                InputFormWithSubtitleWidget(
                  subtitle: 'END DATE & TIME',
                  controller: provider.eventEndDateController,
                  onPressed: () {
                    onPickedDateTime(context,
                        initialDate: provider.initialEndDate,
                        onComplete: (DateTime date, TimeOfDay time) {
                      provider.endEventDateTime(date, time);
                    });
                  },
                  isFormDisabled: true,
                ),
                CreateCommunityEventAddAudience(
                  controller: provider.eventFormAudienceController,
                  defaultAudienceNumber: ['10', '20', '40', '80'],
                  onTap: (v) => provider.eventFormAudienceController.text = v,
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

  onPickedDateTime(BuildContext context,
      {Function(DateTime, TimeOfDay) onComplete, DateTime initialDate}) async {
    DateTime date = await showDatePicker(
      context: context,
      firstDate: initialDate ?? DateTime.now().add(Duration(days: 1)),
      lastDate: DateTime(DateTime.now().year + 5),
      initialDate: initialDate ?? DateTime.now().add(Duration(days: 1)),
    );
    if (date != null) {
      TimeOfDay t = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (t != null) {
        onComplete(date, t);
      }
    }
  }
}
