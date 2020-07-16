import 'package:equatable/equatable.dart';
import 'package:localin/model/explore/explore_event_detail_model.dart';

import 'base_schedule_model.dart';
import 'explore_available_event_dates_model.dart';

class ExploreScheduleModel extends BaseScheduleModel with EquatableMixin {
  ExploreScheduleModel({
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
    this.available,
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
  List<ExploreAvailableEventDatesDetail> available;

  factory ExploreScheduleModel.fromJson(Map<String, dynamic> json) =>
      ExploreScheduleModel(
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
        available: json['available_tiket'] == null
            ? []
            : List<ExploreAvailableEventDatesDetail>.from(
                json['available_tiket']
                    .map((e) => ExploreAvailableEventDatesDetail.fromJson(e))),
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

  @override
  List<Object> get props => [
        idSchedule,
        startDate,
        endDate,
        useSeatingChart,
        tax,
        formOption,
        formOption,
        statusSchedule,
        statusScheduleName,
        refundStatus,
        location
      ];
}
