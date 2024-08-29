import 'package:localin/model/article/base_response.dart';
import 'package:localin/model/explore/explore_event_response_model.dart';

class TransactionExploreDetailResponse extends BaseResponse {
  @override
  bool error;

  @override
  String message;

  Data data;

  TransactionExploreDetailResponse({this.error, this.message, this.data});

  TransactionExploreDetailResponse.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  TransactionExploreDetailResponse.withError(String value)
      : message = value,
        error = true;
}

class Data {
  String transactionId;
  String description;
  String invoiceCode;
  int invoiceQuantityTotal;
  int invoiceTotal;
  int discount;
  int adminFee;
  int totalPayment;
  String status;
  String createdAt;
  String expiredAt;
  Event event;
  Schedule schedule;
  List<Attendees> attendees;
  int basicFee;
  int basicServiceFee;
  int couponDiscount;
  int pointDiscount;
  int basicTax;

  Data({
    this.transactionId,
    this.description,
    this.invoiceCode,
    this.invoiceQuantityTotal,
    this.invoiceTotal,
    this.discount,
    this.adminFee,
    this.totalPayment,
    this.status,
    this.createdAt,
    this.expiredAt,
    this.event,
    this.schedule,
    this.attendees,
    this.basicFee,
    this.basicServiceFee,
    this.couponDiscount,
    this.pointDiscount,
    this.basicTax,
  });

  Data.fromJson(Map<String, dynamic> json) {
    transactionId = json['transaksi_id'];
    description = json['keterangan'];
    invoiceCode = json['invoice_code'];
    invoiceQuantityTotal = json['invoice_quantity_total'];
    invoiceTotal = json['invoice_total'];
    discount = json['diskon'];
    adminFee = json['admin_fee'];
    totalPayment = json['total_bayar'];
    status = json['status'];
    createdAt = json['created_at'];
    expiredAt = json['expired_at'];
    basicFee = json['dasar_harga'] ?? 0;
    basicServiceFee = json['dasar_service'] ?? 0;
    couponDiscount = json['diskon_kupon'] ?? 0;
    pointDiscount = json['diskon_poin'] ?? 0;
    basicTax = json['dasar_ppn'] ?? 0;
    event = json['event'] != null ? Event.fromJson(json['event']) : null;
    schedule =
        json['jadwal'] != null ? Schedule.fromJson(json['jadwal']) : null;
    if (json['attendees'] != null) {
      attendees = List<Attendees>();
      json['attendees'].forEach((v) {
        attendees.add(new Attendees.fromJson(v));
      });
    }
  }
}

class Event {
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

  Event(
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
      this.statusEventName});

  Event.fromJson(Map<String, dynamic> json) {
    idEvent = json['id_event'];
    eventName = json['event_name'];
    description = json['description'];
    eventCapacity = json['event_capacity'];
    startDate = json['start_date'] == null
        ? DateTime.now()
        : DateTime.parse(json['start_date']);
    endDate = json['end_date'] == null
        ? DateTime.now()
        : DateTime.parse(json['end_date']);
    startPrice = json['start_price'];
    endPrice = json['end_price'];
    eventBanner = json['event_banner'];
    idOrganization = json['id_organization'];
    organizationName = json['organization_name'];
    organizationAvatar = json['organization_avatar'];
    statusEvent = json['status_event'];
    statusEventName = json['status_event_name'];
  }
}

class Attendees {
  String attendanceId;
  String orderId;
  int idAttendee;
  String barcodeId;
  String firstName;
  String lastName;
  String createdAt;
  String updatedAt;

  Attendees(
      {this.attendanceId,
      this.orderId,
      this.idAttendee,
      this.barcodeId,
      this.firstName,
      this.lastName,
      this.createdAt,
      this.updatedAt});

  Attendees.fromJson(Map<String, dynamic> json) {
    attendanceId = json['peserta_id'];
    orderId = json['order_id'];
    idAttendee = json['id_attendee'];
    barcodeId = json['barcode_id'];
    firstName = json['firstname'];
    lastName = json['lastname'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}
