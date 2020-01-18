class DanaUserAccountResponse {
  bool error;
  String message;
  DanaAccountDetail data;

  DanaUserAccountResponse({this.error, this.message, this.data});

  factory DanaUserAccountResponse.fromJson(Map<String, dynamic> body) {
    return DanaUserAccountResponse(
      error: null,
      message: body['message'],
      data: body['error'] == false
          ? DanaAccountDetail.fromJson(body['data'])
          : null,
    );
  }

  DanaUserAccountResponse.withError()
      : error = true,
        message = null,
        data = null;
}

class DanaAccountDetail {
  String ott;
  int balance;
  String maskDanaId;
  String urlTopUp;

  DanaAccountDetail({this.ott, this.balance, this.maskDanaId, this.urlTopUp});

  factory DanaAccountDetail.fromJson(Map<String, dynamic> body) {
    return DanaAccountDetail(
      ott: body['OTT'],
      balance: body['BALANCE'],
      maskDanaId: body['MASK_DANA_ID'],
      urlTopUp: body['url_topup'],
    );
  }
}
