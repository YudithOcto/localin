import 'package:equatable/equatable.dart';
import 'package:localin/model/article/tag_model_model.dart';

import 'base_event_request_model.dart';

class ExploreEventResponseModel extends BaseEventRequestmodel {
  bool error;
  String message;
  int total;
  List<ExploreEventDetail> detail;
  List<ExploreSearchLocation> listSearchLocation;

  ExploreEventResponseModel(
      {this.error,
      this.message,
      this.total,
      this.detail,
      this.listSearchLocation});

  ExploreEventResponseModel.withError(String value)
      : message = value,
        total = 0,
        error = true,
        detail = [],
        listSearchLocation = [];

  factory ExploreEventResponseModel.fromJson(Map<String, dynamic> json) {
    return ExploreEventResponseModel(
      error: false,
      message: json['message'],
      total: json['data']['pagination']['total'],
      listSearchLocation: json['data']['location'] == null
          ? []
          : List<ExploreSearchLocation>.from(json['data']['location']
              .map((e) => ExploreSearchLocation.fromJson(e))),
      detail: json['data']['data'] == null
          ? []
          : List<ExploreEventDetail>.from(
              json['data']['data'].map((e) => ExploreEventDetail.fromMap(e))),
    );
  }
}

class ExploreSearchLocation extends BaseEventRequestmodel with EquatableMixin {
  @override
  List<Object> get props => [districtName, total];

  String districtName;
  int total;

  ExploreSearchLocation({this.districtName, this.total});

  factory ExploreSearchLocation.fromJson(Map<String, dynamic> body) {
    return ExploreSearchLocation(
      districtName: body['district_name'],
      total: body['total'],
    );
  }
}

class ExploreEventDetail extends BaseEventRequestmodel {
  ExploreEventDetail(
      {this.idEvent,
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
      this.category,
      this.tags,
      this.location});

  final int idEvent;
  final String eventName;
  final String description;
  final int eventCapacity;
  final DateTime startDate;
  final DateTime endDate;
  final int startPrice;
  final int endPrice;
  final String eventBanner;
  final int idOrganization;
  final String organizationName;
  final String organizationAvatar;
  final int statusEvent;
  final String statusEventName;
  final List<Category> category;
  final List<TagModel> tags;
  final ExploreEventLocation location;

  factory ExploreEventDetail.fromMap(Map<String, dynamic> json) =>
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
          category: List<Category>.from(
              json["category"].map((x) => Category.fromMap(x))),
          tags: List<TagModel>.from(
              json["tags"].map((x) => TagModel.fromJson(x))),
          location: json['location'] == null
              ? null
              : ExploreEventLocation.fromJson(
                  json['location'],
                ));
}

class Category {
  Category({
    this.categoryId,
    this.categoryName,
  });

  final String categoryId;
  final String categoryName;

  factory Category.fromMap(Map<String, dynamic> json) => Category(
        categoryId: json["kategori_id"],
        categoryName: json["category_name"],
      );
}

class Schedule {
  Schedule({
    this.idSchedule,
    this.idEvent,
    this.useSeatingChart,
    this.startDate,
    this.endDate,
    this.status,
    this.statusName,
    this.address,
    this.districtName,
    this.latitude,
    this.longitude,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  final int idSchedule;
  final int idEvent;
  final int useSeatingChart;
  final DateTime startDate;
  final DateTime endDate;
  final int status;
  final String statusName;
  final String address;
  final String districtName;
  final String latitude;
  final String longitude;
  final DateTime createdAt;
  final DateTime updatedAt;
  final dynamic deletedAt;

  factory Schedule.fromJson(Map<String, dynamic> json) => Schedule(
        idSchedule: json["id_schedule"],
        idEvent: json["id_event"],
        useSeatingChart: json["use_seating_chart"],
        startDate: DateTime.parse(json["start_date"]),
        endDate: DateTime.parse(json["end_date"]),
        status: json["status"],
        statusName: json["status_name"],
        address: json["address"],
        districtName: json["district_name"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
      );
}

class ExploreEventLocation {
  String address;
  String districtName;
  String latitude;
  String longitude;

  ExploreEventLocation(
      {this.address, this.districtName, this.latitude, this.longitude});

  factory ExploreEventLocation.fromJson(Map<String, dynamic> json) =>
      ExploreEventLocation(
        address: json['address'],
        districtName: json['district_name'],
        latitude: json['latitude'],
        longitude: json['longitude'],
      );
}
