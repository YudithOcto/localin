import 'package:equatable/equatable.dart';
import 'package:localin/model/explore/base_schedule_model.dart';

class ExploreScheduleTitle extends BaseScheduleModel with EquatableMixin {
  DateTime startDate;
  DateTime endDate;

  ExploreScheduleTitle({this.startDate, this.endDate});

  @override
  List<Object> get props => [startDate, endDate];
}
