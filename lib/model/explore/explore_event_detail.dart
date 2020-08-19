import 'package:localin/model/explore/explore_schedule_model.dart';

import 'explore_available_event_dates_model.dart';

class ExploreEventDetail {
  ExploreEventDetail({
    this.idEvent,
    this.eventName,
    this.description,
    this.eventCapacity,
    this.startDate,
    this.endDate,
    this.startPrice,
    this.endPrice,
    this.eventBanner,
    this.idOrganization,
    this.organizationName,
    this.organizationAvatar,
    this.statusEvent,
    this.statusEventName,
    this.schedules,
    this.available,
  });

  int idEvent;
  String eventName;
  String description;
  int eventCapacity;
  DateTime startDate;
  DateTime endDate;
  int startPrice;
  int endPrice;
  String eventBanner;
  int idOrganization;
  String organizationName;
  String organizationAvatar;
  int statusEvent;
  String statusEventName;
  List<ExploreScheduleModel> schedules;
  List<ExploreAvailableEventDatesDetail> available;

  factory ExploreEventDetail.fromJson(Map<String, dynamic> json) =>
      ExploreEventDetail(
        idEvent: json["id_event"],
        eventName: json["event_name"],
        description: json["description"],
        eventCapacity: json["event_capacity"],
        startDate: DateTime.parse(json["start_date"]),
        endDate: DateTime.parse(json["end_date"]),
        startPrice: json["start_price"],
        endPrice: json["end_price"],
        eventBanner: json["event_banner"],
        idOrganization: json["id_organization"],
        organizationName: json["organization_name"],
        organizationAvatar: json["organization_avatar"],
        statusEvent: json["status_event"],
        statusEventName: json["status_event_name"],
        schedules: json['schedules'] == null
            ? []
            : List<ExploreScheduleModel>.from(
                json["schedules"].map((x) => ExploreScheduleModel.fromJson(x))),
        available: json['available_tiket'] == null
            ? []
            : List<ExploreAvailableEventDatesDetail>.from(
                json['available_tiket']
                    .map((e) => ExploreAvailableEventDatesDetail.fromJson(e))),
      );
}
