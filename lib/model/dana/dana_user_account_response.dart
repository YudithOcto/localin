class DanaUserAccountResponse {
  bool error;
  String message;
  List data;

  DanaUserAccountResponse({this.error, this.message, this.data});

  factory DanaUserAccountResponse.fromJson(Map<String, dynamic> body) {
    List data = body['data'];
    return DanaUserAccountResponse(
      error: null,
      message: body['message'],
      data: data,
    );
  }

  DanaUserAccountResponse.withError()
      : error = true,
        message = null,
        data = null;
}
