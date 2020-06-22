class TransactionCommunityResponseModel {
  bool error;
  String message;
  TransactionCommunityDetail data;
  int total;
  List<TransactionCommunityDetail> transactionList;

  TransactionCommunityResponseModel(
      {this.error, this.message, this.data, this.transactionList, this.total});

  factory TransactionCommunityResponseModel.fromJson(
      Map<String, dynamic> data) {
    return TransactionCommunityResponseModel(
        error: false,
        message: null,
        data: TransactionCommunityDetail.fromMap(data['data']));
  }

  factory TransactionCommunityResponseModel.getListJson(
      Map<String, dynamic> data) {
    return TransactionCommunityResponseModel(
        error: false,
        message: data['message'],
        total: data['data']['paging']['total'],
        transactionList: List<TransactionCommunityDetail>.from(data['data']
                ['data']
            .map((e) => TransactionCommunityDetail.fromMap(e))));
  }

  TransactionCommunityResponseModel.withError(String value)
      : error = true,
        message = value,
        data = null;
}

class TransactionCommunityDetail {
  String transactionId;
  String description;
  int adminFee;
  int discount;
  int totalPayment;
  String status;
  String createdAt;
  String expiredAt;
  int basicPayment;
  String transactionTypeId;

  TransactionCommunityDetail({
    this.transactionId,
    this.description,
    this.adminFee,
    this.discount,
    this.totalPayment,
    this.status,
    this.createdAt,
    this.expiredAt,
    this.basicPayment,
    this.transactionTypeId,
  });

  factory TransactionCommunityDetail.fromMap(Map<String, dynamic> body) {
    return TransactionCommunityDetail(
      transactionId: body['transaksi_id'],
      description: body['keterangan'],
      discount: body['discount'],
      adminFee: body['admin_fee'],
      totalPayment: body['total_bayar'],
      status: body['status'],
      createdAt: body['created_at'],
      expiredAt: body['expired_at'],
      basicPayment: body['dasar_bayar'],
      transactionTypeId: body['modul_id'],
    );
  }
}
