class CommunityJoinResponse {
  String error;
  String message;

  CommunityJoinResponse({this.error, this.message});

  CommunityJoinResponse.fromJson(Map<String, dynamic> body)
      : error = null,
        message = body['message'];

  CommunityJoinResponse.withError(String error)
      : error = error,
        message = null;
}
