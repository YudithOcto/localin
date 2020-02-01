class UserRequest {
  String userId;
  String userEmail;
  String userName;
  String userSource;
  String userPhoto;
  String fcmToken;

  UserRequest({
    this.userId,
    this.userEmail,
    this.userName,
    this.userSource,
    this.userPhoto,
    this.fcmToken,
  });

  factory UserRequest.fromJson(Map<String, dynamic> body) {
    return UserRequest(
        userId: body['user_id'],
        userEmail: body['user_email'],
        userName: body['user_name'],
        userPhoto: body['user_photo'],
        userSource: body['source']);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = Map();
    map['user_id'] = userId;
    map['user_email'] = userEmail;
    map['user_name'] = userName;
    map['source'] = userSource;
    map['user_photo'] = userPhoto;
    return map;
  }
}
