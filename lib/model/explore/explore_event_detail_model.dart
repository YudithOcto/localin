import 'package:localin/model/explore/explore_base_model.dart';

import 'explore_available_event_dates_model.dart';
import 'explore_event_detail.dart';

class ExploreEventDetailModel implements BaseModel {
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
