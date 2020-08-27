import 'package:localin/model/explore/explore_schedule_model.dart';

import 'explore_available_event_dates_model.dart';
import 'explorer_event_category_detail.dart';

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
    this.category,
    this.schedulesCount,
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
  int schedulesCount;
  List<ExploreScheduleModel> schedules;
  List<ExploreAvailableEventDatesDetail> available;
  List<ExploreEventCategoryDetail> category;

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
        schedulesCount: json['schedules_count'],
        schedules: json['schedules'] == null
            ? []
            : List<ExploreScheduleModel>.from(
                json["schedules"].map((x) => ExploreScheduleModel.fromJson(x))),
        available: json['available_tiket'] == null
            ? []
            : List<ExploreAvailableEventDatesDetail>.from(
                json['available_tiket']
                    .map((e) => ExploreAvailableEventDatesDetail.fromJson(e))),
        category: json['kategori'] == null
            ? []
            : List<ExploreEventCategoryDetail>.from(json['kategori']
                .map((e) => ExploreEventCategoryDetail.fromMap(e))),
      );
}
