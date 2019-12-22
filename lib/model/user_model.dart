class UserModel {
  String username;
  String email;
  String picture;

  UserModel({this.username, this.email, this.picture});

  factory UserModel.fromJson(Map<String, dynamic> body) {
    return UserModel(
        username: body['username'],
        email: body['email'],
        picture: body['picture']);
  }

  Map<String, dynamic> toJson() {
    var map = Map();
    map['username'] = username;
    map['email'] = email;
    map['picture'] = picture;
    return map;
  }
}
