import 'package:flutter/material.dart';

class TransactionResponseModel {
  bool error;
  String message;
  TransactionDetail data;

  TransactionResponseModel({this.error, this.message, this.data});

  factory TransactionResponseModel.fromJson(Map<String, dynamic> data) {
    return TransactionResponseModel(
        error: false,
        message: null,
        data: TransactionDetail.fromMap(data['data']));
  }

  TransactionResponseModel.withError(String value)
      : error = true,
        message = value,
        data = null;
}

class TransactionDetail {
  String transactionId;
  String description;
  int adminFee;
  int discount;
  int totalPayment;
  String status;
  String createdAt;
  String expiredAt;
  int basicPayment;

  TransactionDetail(
      {this.transactionId,
      this.description,
      this.adminFee,
      this.discount,
      this.totalPayment,
      this.status,
      this.createdAt,
      this.expiredAt,
      this.basicPayment});

  factory TransactionDetail.fromMap(Map<String, dynamic> body) {
    return TransactionDetail(
      transactionId: body['transaksi_id'],
      description: body['keterangan'],
      discount: body['discount'],
      adminFee: body['admin_fee'],
      totalPayment: body['total_bayar'],
      status: body['status'],
      createdAt: body['created_at'],
      expiredAt: body['expired_at'],
      basicPayment: body['dasar_bayar'],
    );
  }
}
