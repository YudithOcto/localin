import 'package:equatable/equatable.dart';

class SubmitFormRequestModel with EquatableMixin {
  @override
  List<Object> get props => [eventName, profileTicket, usePoint, coupon];

  String eventName;
  String coupon;
  int usePoint;
  List<SubmitProfileTicketModel> profileTicket;

  SubmitFormRequestModel(
      {this.eventName, this.profileTicket, this.usePoint, this.coupon});

  Map<String, dynamic> toJson() => {
        'event_name': eventName,
        'data': List<dynamic>.from(profileTicket.map((e) => e.toJson())),
        'kupon': coupon,
        'use_poin': usePoint,
      };
}

class SubmitProfileTicketModel with EquatableMixin {
  int idTicket;
  List<String> visitorNames;

  @override
  List<Object> get props => [visitorNames, idTicket];

  SubmitProfileTicketModel({this.idTicket, this.visitorNames});

  Map<String, dynamic> toJson() => {
        'id_ticket': idTicket,
        'nama': List<dynamic>.from(visitorNames.map((e) => e)),
      };
}
