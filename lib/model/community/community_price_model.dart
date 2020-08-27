class CommunityPriceModel {
  bool error;
  String message;
  CommunityPriceDetail detail;

  CommunityPriceModel({this.error, this.message, this.detail});

  factory CommunityPriceModel.fromJson(Map<String, dynamic> body) {
    return CommunityPriceModel(
      error: false,
      message: body['message'],
      detail: CommunityPriceDetail.fromJson(
        body['data'],
      ),
    );
  }

  CommunityPriceModel.withError(String value)
      : error = true,
        message = value,
        detail = CommunityPriceDetail();
}

class CommunityPriceDetail {
  int basicFare;
  int adminFare;
  int totalFare;
  bool isFreeCommunityAvailable;

  CommunityPriceDetail(
      {this.basicFare,
      this.adminFare,
      this.totalFare,
      this.isFreeCommunityAvailable});

  factory CommunityPriceDetail.fromJson(Map<String, dynamic> json) {
    return CommunityPriceDetail(
      basicFare: json['dasar_bayar'],
      adminFare: json['admin_fee'],
      totalFare: json['biaya'],
      isFreeCommunityAvailable: json['free-community'] ?? false,
    );
  }
}
