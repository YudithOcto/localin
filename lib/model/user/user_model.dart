class UserModel {
  String id;
  String address;
  String shortBio;
  String imageProfile;
  String imageIdentity;
  String identityNo;
  String status;
  String source;
  String apiToken;
  String username;
  String email;
  String error;
  String handphone;
  int points;
  int views;
  int posts;
  String latitude;
  String longitude;

  UserModel({
    this.id,
    this.address,
    this.shortBio,
    this.imageProfile,
    this.imageIdentity,
    this.identityNo,
    this.status,
    this.source,
    this.apiToken,
    this.username,
    this.error,
    this.email,
    this.handphone,
    this.points,
    this.views,
    this.posts,
    this.latitude,
    this.longitude,
  });

  factory UserModel.fromJson(Map<String, dynamic> body) {
    return UserModel(
      id: body['id'],
      address: body['alamat'],
      shortBio: body['short_bio'],
      imageProfile: body['image_profile'],
      imageIdentity: body['image_identitas'],
      identityNo: body['no_identitas'],
      status: body['status'],
      source: body['source'],
      apiToken: body['api_token'],
      username: body['nama'],
      email: body['email'],
      handphone: body['handphone'],
      points: body['point'] ?? 0,
      views: body['views'] ?? 0,
      posts: body['posts'] ?? 0,
      latitude: body['lat'] ?? 0.0,
      longitude: body['long'] ?? 0.0,
    );
  }

  factory UserModel.withError(String value) {
    return UserModel(error: value);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = Map();
    map['id'] = id;
    map['alamat'] = address;
    map['short_bio'] = shortBio;
    map['image_profile'] = imageProfile;
    map['image_identitas'] = imageIdentity;
    map['no_identitas'] = identityNo;
    map['status'] = status;
    map['source'] = source;
    map['api_token'] = apiToken;
    map['nama'] = username;
    map['email'] = email;
    map['handphone'] = handphone;
    map['lat'] = latitude;
    map['long'] = longitude;
    return map;
  }
}
