class ExploreEventSubmissionDetails {
  String eventImage;
  String eventName;
  String eventDate;
  int totalPrice;
  int ticketPrice;
  int totalTicket;
  Map<String, int> previousTicketTypeWithTotal;

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
