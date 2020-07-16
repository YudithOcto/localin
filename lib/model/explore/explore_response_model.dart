import 'package:equatable/equatable.dart';

class ExploreOrderResponseModel with EquatableMixin {
  ExploreOrderResponseModel({
    this.error,
    this.message,
    this.data,
  });

  bool error;
  String message;
  ExploreOrderDetail data;

  factory ExploreOrderResponseModel.fromJson(Map<String, dynamic> json) =>
      ExploreOrderResponseModel(
        error: json["error"],
        message: json["message"],
        data: ExploreOrderDetail.fromJson(json["data"]),
      );

  ExploreOrderResponseModel.withError(String value)
      : message = value,
        error = true;

  @override
  List<Object> get props => [error, message, data];
}

class ExploreOrderDetail {
  ExploreOrderDetail({
    this.orderId,
    this.memberId,
    this.createdAt,
    this.expiredAt,
    this.updatedAt,
    this.token,
    this.eventName,
    this.idInvoice,
    this.idOrder,
    this.idEvent,
    this.idSchedule,
    this.invoiceCode,
    this.statusInvoice,
    this.statusInvoiceName,
    this.invoiceQuantityTotal,
    this.invoicePriceTotal,
    this.invoiceTax,
    this.invoiceFee,
    this.insuranceFee,
    this.shippingFee,
    this.discount,
    this.invoicePaymentTotal,
    this.transaksiId,
  });

  String orderId;
  String memberId;
  DateTime createdAt;
  DateTime expiredAt;
  DateTime updatedAt;
  String token;
  String eventName;
  int idInvoice;
  String idOrder;
  int idEvent;
  int idSchedule;
  String invoiceCode;
  int statusInvoice;
  String statusInvoiceName;
  int invoiceQuantityTotal;
  int invoicePriceTotal;
  int invoiceTax;
  int invoiceFee;
  int insuranceFee;
  int shippingFee;
  int discount;
  int invoicePaymentTotal;
  String transaksiId;

  factory ExploreOrderDetail.fromJson(Map<String, dynamic> json) =>
      ExploreOrderDetail(
        orderId: json["order_id"],
        memberId: json["member_id"],
        createdAt: DateTime.parse(json["created_at"]),
        expiredAt: DateTime.parse(json["expired_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        token: json["token"],
        eventName: json["event_name"],
        idInvoice: json["id_invoice"],
        idOrder: json["id_order"],
        idEvent: json["id_event"],
        idSchedule: json["id_schedule"],
        invoiceCode: json["invoice_code"],
        statusInvoice: json["status_invoice"],
        statusInvoiceName: json["status_invoice_name"],
        invoiceQuantityTotal: json["invoice_quantity_total"],
        invoicePriceTotal: json["invoice_price_total"],
        invoiceTax: json["invoice_tax"],
        invoiceFee: json["invoice_fee"],
        insuranceFee: json["insurance_fee"],
        shippingFee: json["shipping_fee"],
        discount: json["discount"],
        invoicePaymentTotal: json["invoice_payment_total"],
        transaksiId: json["transaksi_id"],
      );
}
