import 'package:localin/model/explore/explore_base_model.dart';

import 'explore_available_event_dates_model.dart';

class ExploreEventDetailModel implements ExploreBaseModel {
  @override
  var detail;

  @override
  bool error;

  @override
  String message;

  @override
  int total;

  ExploreEventDetailModel({this.detail, this.error, this.message, this.total});

  ExploreEventDetailModel.withError(String value)
      : detail = null,
        error = true,
        message = value,
        total = 0;

  factory ExploreEventDetailModel.fromJson(Map<String, dynamic> json) {
    return ExploreEventDetailModel(
      detail: ExploreEventDetail.fromJson(json['data']),
      total: 0,
      error: false,
      message: json['message'],
    );
  }
}

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
  List<Schedule> schedules;
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
        schedules: List<Schedule>.from(
            json["schedules"].map((x) => Schedule.fromJson(x))),
        available: List<ExploreAvailableEventDatesDetail>.from(json['available']
            .map((e) => ExploreAvailableEventDatesDetail.fromJson(e))),
      );

  Map<String, dynamic> toJson() => {
        "id_event": idEvent,
        "event_name": eventName,
        "description": description,
        "event_capacity": eventCapacity,
        "start_date": startDate.toIso8601String(),
        "end_date": endDate.toIso8601String(),
        "start_price": startPrice,
        "end_price": endPrice,
        "event_banner": eventBanner,
        "id_organization": idOrganization,
        "organization_name": organizationName,
        "organization_avatar": organizationAvatar,
        "status_event": statusEvent,
        "status_event_name": statusEventName,
        "schedules": List<dynamic>.from(schedules.map((x) => x.toJson())),
      };
}

class Schedule {
  Schedule({
    this.idSchedule,
    this.startDate,
    this.endDate,
    this.useSeatingChart,
    this.tax,
    this.formOption,
    this.statusSchedule,
    this.statusScheduleName,
    this.refundStatus,
    this.location,
  });

  int idSchedule;
  DateTime startDate;
  DateTime endDate;
  bool useSeatingChart;
  int tax;
  List<String> formOption;
  int statusSchedule;
  String statusScheduleName;
  int refundStatus;
  Location location;

  factory Schedule.fromJson(Map<String, dynamic> json) => Schedule(
        idSchedule: json["id_schedule"],
        startDate: DateTime.parse(json["start_date"]),
        endDate: DateTime.parse(json["end_date"]),
        useSeatingChart: json["use_seating_chart"],
        tax: json["tax"],
        formOption: List<String>.from(json["form_option"].map((x) => x)),
        statusSchedule: json["status_schedule"],
        statusScheduleName: json["status_schedule_name"],
        refundStatus: json["refund_status"],
        location: Location.fromJson(json["location"]),
      );

  Map<String, dynamic> toJson() => {
        "id_schedule": idSchedule,
        "start_date": startDate.toIso8601String(),
        "end_date": endDate.toIso8601String(),
        "use_seating_chart": useSeatingChart,
        "tax": tax,
        "form_option": List<dynamic>.from(formOption.map((x) => x)),
        "status_schedule": statusSchedule,
        "status_schedule_name": statusScheduleName,
        "refund_status": refundStatus,
        "location": location.toJson(),
      };
}

class Location {
  Location({
    this.idLocation,
    this.locationName,
    this.idCountry,
    this.countryName,
    this.idProvince,
    this.provinceName,
    this.idDistrict,
    this.districtName,
    this.idRegion,
    this.regionName,
    this.address,
    this.postalCode,
    this.latitude,
    this.longitude,
    this.statusLocation,
    this.statusLocationName,
  });

  int idLocation;
  String locationName;
  int idCountry;
  String countryName;
  int idProvince;
  String provinceName;
  int idDistrict;
  String districtName;
  int idRegion;
  String regionName;
  String address;
  dynamic postalCode;
  double latitude;
  double longitude;
  int statusLocation;
  String statusLocationName;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        idLocation: json["id_location"],
        locationName: json["location_name"],
        idCountry: json["id_country"],
        countryName: json["country_name"],
        idProvince: json["id_province"],
        provinceName: json["province_name"],
        idDistrict: json["id_district"],
        districtName: json["district_name"],
        idRegion: json["id_region"],
        regionName: json["region_name"],
        address: json["address"],
        postalCode: json["postal_code"],
        latitude: json["latitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
        statusLocation: json["status_location"],
        statusLocationName: json["status_location_name"],
      );

  Map<String, dynamic> toJson() => {
        "id_location": idLocation,
        "location_name": locationName,
        "id_country": idCountry,
        "country_name": countryName,
        "id_province": idProvince,
        "province_name": provinceName,
        "id_district": idDistrict,
        "district_name": districtName,
        "id_region": idRegion,
        "region_name": regionName,
        "address": address,
        "postal_code": postalCode,
        "latitude": latitude,
        "longitude": longitude,
        "status_location": statusLocation,
        "status_location_name": statusLocationName,
      };
}
