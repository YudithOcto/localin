class DanaActivateBaseResponse {
  String message;
  bool error;
  String urlRedirect;

  DanaActivateBaseResponse({this.message, this.error, this.urlRedirect});

  factory DanaActivateBaseResponse.fromJson(Map<String, dynamic> body) {
    return DanaActivateBaseResponse(
        message: body['message'],
        error: body['error'],
        urlRedirect: body['data']['url_redirect']);
  }

  DanaActivateBaseResponse.withError(String value)
      : error = true,
        urlRedirect = '',
        message = value;
}
