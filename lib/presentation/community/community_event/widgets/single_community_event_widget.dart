import 'package:flutter/material.dart';
import 'package:localin/components/custom_dialog.dart';
import 'package:localin/components/custom_image_only_radius.dart';
import 'package:localin/components/filled_button_default.dart';
import 'package:localin/model/community/community_detail.dart';
import 'package:localin/model/community/community_event_response_model.dart';
import 'package:localin/presentation/community/community_event/community_create_event_page.dart';
import 'package:localin/presentation/community/community_event/community_event_detail_page.dart';
import 'package:localin/presentation/community/community_event/provider/community_event_provider.dart';
import 'package:localin/provider/auth_provider.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

class SingleCommunityEvent extends StatelessWidget {
  final EventResponseData event;
  final int index;
  final bool isPastEvent;

  SingleCommunityEvent({this.event, this.index, this.isPastEvent});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          InkWell(
            onTap: () {
              CommunityDetail cDetail = CommunityDetail(
                  id: event.communityId,
                  slug: event.communitySlug,
                  joinStatus: event.communityJoinStatus,
                  name: event.communityName,
                  logo: event.communityLogo);
              Navigator.of(context)
                  .pushNamed(CommunityEventDetailPage.routeName, arguments: {
                CommunityEventDetailPage.eventSlug: event.id,
                CommunityEventDetailPage.communityData: cDetail,
              });
            },
            child: CustomImageOnlyRadius(
              imageUrl: event?.attachment?.first?.attachment ?? '',
              width: double.maxFinite,
              height: 157.0,
              topRight: 8.0,
              topLeft: 8.0,
              placeHolderColor: ThemeColors.black100,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: ThemeColors.black0,
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(8.0),
                    bottomLeft: Radius.circular(8.0))),
            padding: EdgeInsets.only(top: 16.0),
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 12.0, right: 12.0),
                        padding: EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 12.0),
                        decoration: BoxDecoration(
                            color: ThemeColors.black10,
                            borderRadius: BorderRadius.circular(8.0)),
                        child: Column(
                          children: <Widget>[
                            Text(
                              '${event.startDate.month.monthCharacter}',
                              style: ThemeText.sfSemiBoldFootnote
                                  .copyWith(color: ThemeColors.black80),
                            ),
                            Text(
                              '${event.startDate.day}',
                              style: ThemeText.sfSemiBoldTitle3
                                  .copyWith(color: ThemeColors.orange),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(right: 12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                '${event?.title}',
                                maxLines: 2,
                                style: ThemeText.sfRegularHeadline,
                              ),
                              Visibility(
                                visible: event.address.isNotEmpty,
                                child: Text(
                                  '${event?.address}',
                                  maxLines: 2,
                                  style: ThemeText.sfRegularBody
                                      .copyWith(color: ThemeColors.black80),
                                ),
                              ),
                              SizedBox(
                                height: 2.0,
                              ),
                              Text('${event?.startTime} - ${event?.endTime}',
                                  style: ThemeText.sfRegularBody
                                      .copyWith(color: ThemeColors.black80)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0.0,
                  right: 0.0,
                  child: Visibility(
                    visible: event.createdBy ==
                        Provider.of<AuthProvider>(context, listen: false)
                            .userModel
                            .id,
                    child: Consumer<CommunityEventProvider>(
                      builder: (context, provider, child) {
                        return PopupMenuButton<String>(
                            icon: Icon(
                              Icons.more_vert,
                              color: ThemeColors.black100,
                            ),
                            onSelected: (v) async {
                              if (v == EVENT_EDIT) {
                                final model =
                                    await provider.getEventRequestModel(index);
                                CommunityDetail cDetail = CommunityDetail(
                                  id: event.communityId,
                                  slug: event.communitySlug,
                                  joinStatus: event.communityJoinStatus,
                                  logo: event.communityLogo,
                                  name: event.communityName,
                                );
                                final result = await Navigator.of(context)
                                    .pushNamed(
                                        CommunityCreateEventPage.routeName,
                                        arguments: {
                                      CommunityCreateEventPage.communityData:
                                          cDetail,
                                      CommunityCreateEventPage
                                          .previousEventModel: model,
                                    });
                              } else {
                                showEventsDialog(context,
                                    type: v, eventId: event.id);
                              }
                            },
                            itemBuilder: (context) {
                              return provider.popupItem
                                  .map((e) => PopupMenuItem(
                                        value: e,
                                        child: Text('$e'),
                                      ))
                                  .toList();
                            });
                      },
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  showEventsDialog(BuildContext context,
      {String type, @required String eventId}) {
    CustomDialog.showCustomDialogVerticalMultipleButton(
      context,
      title: type == EVENT_REMOVE
          ? 'Are you sure remove this event?'
          : 'Are you sure cancel this event?',
      message: type == EVENT_CANCEL
          ? 'Canceled events will not be published again'
          : 'Removed events will not be published again',
      dialogButtons: generalButton(context, type, eventId),
    );
  }

  List<Widget> generalButton(
      BuildContext context, String type, String eventId) {
    List<Widget> widgets = List();
    if (type == EVENT_REMOVE) {
      widgets.add(FilledButtonDefault(
        buttonText: 'Remove This Event',
        textTheme: ThemeText.rodinaTitle3.copyWith(color: ThemeColors.black0),
        onPressed: () async {
          Navigator.of(context).pop();
          CustomDialog.showLoadingDialog(context, message: 'Loading ...');
          final result =
              await Provider.of<CommunityEventProvider>(context, listen: false)
                  .adminUpdateData(status: 'hapus', eventId: eventId);
          CustomDialog.closeDialog(context);
          CustomDialog.showCustomDialogWithButton(
              context, 'Event', result?.message,
              btnText: 'Close');
          if (isPastEvent) {
            Provider.of<CommunityEventProvider>(context, listen: false)
                .getPastEvent(isRefresh: true);
          } else {
            Provider.of<CommunityEventProvider>(context, listen: false)
                .getUpcomingEvent(isRefresh: true);
          }
        },
      ));
    } else {
      widgets.add(FilledButtonDefault(
        textTheme: ThemeText.rodinaTitle3.copyWith(color: ThemeColors.black0),
        buttonText: 'Cancel This Event',
        onPressed: () async {
          Navigator.of(context).pop();
          CustomDialog.showLoadingDialog(context, message: 'Loading ...');
          final result =
              await Provider.of<CommunityEventProvider>(context, listen: false)
                  .adminUpdateData(status: 'batal', eventId: eventId);
          CustomDialog.closeDialog(context);
          CustomDialog.showCustomDialogWithButton(
              context, 'Event', result?.message,
              btnText: 'Close');
        },
      ));
    }
    widgets.add(getBackButton(context));
    return widgets;
  }

  Widget getBackButton(BuildContext context) {
    return Container(
      alignment: FractionalOffset.center,
      margin: const EdgeInsets.only(top: 10.0),
      child: InkWell(
        onTap: () => Navigator.of(context).pop(),
        child: Text(
          'Cancel',
          textAlign: TextAlign.center,
          style: ThemeText.rodinaTitle3.copyWith(color: ThemeColors.black80),
        ),
      ),
    );
  }
}

extension on int {
  String get monthCharacter {
    switch (this) {
      case 1:
        return 'January';
        break;
      case 2:
        return 'February';
        break;
      case 3:
        return 'March';
        break;
      case 4:
        return 'April';
        break;
      case 5:
        return 'May';
        break;
      case 6:
        return 'June';
        break;
      case 7:
        return 'July';
        break;
      case 8:
        return 'August';
        break;
      case 9:
        return 'September';
        break;
      case 10:
        return 'October';
        break;
      case 11:
        return 'November';
        break;
      case 12:
        return 'December';
        break;
    }
    return '';
  }
}
