class ExploreAvailableEventDatesModel {
  String message;
  List<ExploreAvailableEventDatesDetail> detail;

  ExploreAvailableEventDatesModel({this.detail, this.message});

  factory ExploreAvailableEventDatesModel.fromJson(List data) {
    return ExploreAvailableEventDatesModel(
        message: '',
        detail: List<ExploreAvailableEventDatesDetail>.from(
            data.map((e) => ExploreAvailableEventDatesDetail.fromJson(e))));
  }

  ExploreAvailableEventDatesModel.withError(String value) : message = value;
}

class ExploreAvailableEventDatesDetail {
  ExploreAvailableEventDatesDetail({
    this.idTicket,
    this.idTicketType,
    this.ticketType,
    this.description,
    this.startSale,
    this.endSale,
    this.price,
    this.quantity,
    this.available,
    this.availableQty,
    this.ticketSeatingChart,
    this.ticketColor,
    this.holdEndDate,
    this.holdMessage,
    this.statusTicket,
    this.statusTicketName,
    this.tags,
    this.maxBuyQty,
  });

  int idTicket;
  int idTicketType;
  String ticketType;
  String description;
  DateTime startSale;
  DateTime endSale;
  int price;
  int quantity;
  bool available;
  int availableQty;
  bool ticketSeatingChart;
  dynamic ticketColor;
  dynamic holdEndDate;
  dynamic holdMessage;
  int statusTicket;
  String statusTicketName;
  List<dynamic> tags;
  int maxBuyQty;

  factory ExploreAvailableEventDatesDetail.fromJson(
          Map<String, dynamic> json) =>
      ExploreAvailableEventDatesDetail(
        idTicket: json["id_ticket"],
        idTicketType: json["id_ticket_type"],
        ticketType: json["ticket_type"],
        description: json["description"],
        startSale: DateTime.parse(json["start_sale"]),
        endSale: DateTime.parse(json["end_sale"]),
        price: json["price"],
        quantity: json["quantity"],
        available: json["available"],
        availableQty: json["available_qty"],
        ticketSeatingChart: json["ticket_seating_chart"],
        ticketColor: json["ticket_color"],
        holdEndDate: json["hold_end_date"],
        holdMessage: json["hold_message"],
        statusTicket: json["status_ticket"],
        statusTicketName: json["status_ticket_name"],
        tags: List<dynamic>.from(json["tags"].map((x) => x)),
        maxBuyQty: json["max_buy_qty"],
      );
}
