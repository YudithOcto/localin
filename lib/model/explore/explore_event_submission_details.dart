import 'base_event_request_model.dart';
import 'explore_available_event_dates_model.dart';

class ExploreEventSubmissionDetails {
  String eventImage;
  String eventName;
  String eventDate;
  int totalPrice;
  int ticketPrice;
  int totalTicket;
  List<ExploreAvailableEventDatesDetail> previousTicketTypeWithTotal;

  ExploreEventSubmissionDetails({
    this.eventName,
    this.eventDate,
    this.eventImage,
    this.totalPrice,
    this.ticketPrice,
    this.totalTicket,
    this.previousTicketTypeWithTotal,
  });
}
