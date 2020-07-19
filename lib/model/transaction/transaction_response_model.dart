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
  String modul;
  String description;
  String transactionType;
  int adminFee;
  int discount;
  int totalPayment;
  String status;
  String createdAt;
  String expiredAt;
  int basicPayment;
  String transactionTypeId;
  ServiceDetail serviceDetail;

  TransactionCommunityDetail({
    this.transactionId,
    this.modul,
    this.description,
    this.transactionType,
    this.adminFee,
    this.discount,
    this.totalPayment,
    this.status,
    this.createdAt,
    this.expiredAt,
    this.basicPayment,
    this.transactionTypeId,
    this.serviceDetail,
  });

  factory TransactionCommunityDetail.fromMap(Map<String, dynamic> body) {
    return TransactionCommunityDetail(
      transactionId: body['transaksi_id'],
      modul: body['modul'],
      discount: body['discount'],
      description: body['keterangan'],
      adminFee: body['admin_fee'],
      totalPayment: body['total_bayar'],
      status: body['status'],
      createdAt: body['created_at'],
      expiredAt: body['expired_at'],
      basicPayment: body['dasar_bayar'],
      transactionTypeId: body['modul_id'],
      transactionType: body['modul'],
      serviceDetail: body['service_detail'] == null
          ? null
          : ServiceDetail.fromJson(body['service_detail']),
    );
  }
}

class ServiceDetail {
  String invoiceId;
  String bookingCode;
  String title;
  String duration;
  int totalPayment;
  String communitySlug;
  DateTime startDate;
  DateTime endDate;
  String address;
  String city;
  String latitude;
  String longitude;
  String quantity;

  ServiceDetail({
    this.invoiceId,
    this.bookingCode,
    this.title,
    this.duration,
    this.totalPayment,
    this.communitySlug,
    this.startDate,
    this.endDate,
    this.address,
    this.city,
    this.latitude,
    this.longitude,
    this.quantity,
  });

  factory ServiceDetail.fromJson(Map<String, dynamic> body) {
    return ServiceDetail(
        invoiceId: body['invoice_id'].toString(),
        bookingCode: body['booking_kode'],
        title: body['keterangan'],
        duration: body['quantity'].toString(),
        totalPayment: body['invoice_payment_total'],
        communitySlug: body['community_slug'] ?? '',
        startDate: body['start_date'] == null
            ? DateTime.now()
            : DateTime.parse(body['start_date']),
        endDate: body['end_date'] == null
            ? DateTime.now()
            : DateTime.parse(body['end_date']),
        address: body['address'] == null ? '' : body['address'],
        city: body['kota'] == null ? '' : body['kota'],
        quantity: body['quantity'] == null ? 0 : body['quantity'].toString(),
        latitude: body['latitude'] == null ? '' : body['latitude'],
        longitude: body['longitude'] == null ? '' : body['longitude']);
  }
}
