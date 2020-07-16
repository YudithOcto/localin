import 'package:equatable/equatable.dart';

import 'explore_available_event_dates_model.dart';

class EventRequestModel with EquatableMixin {
  @override
  List<Object> get props => [eventDetail];

  ExploreAvailableEventDatesDetail eventDetail;
}
