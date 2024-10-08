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
    this.transactionId,
    this.urlRedirect,
    this.invoicePaymentTotal,
    this.adminFee,
  });

  String transactionId;
  String urlRedirect;
  int invoicePaymentTotal;
  int adminFee;

  factory ExploreOrderDetail.fromJson(Map<String, dynamic> json) =>
      ExploreOrderDetail(
        transactionId: json["transaksi_id"],
        urlRedirect: json['url_redirect'],
        invoicePaymentTotal: json['invoice_payment_total'],
        adminFee: json['admin_fee'],
      );
}
