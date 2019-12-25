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

  UserModel(
      {this.id,
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
      this.email});

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
    return map;
  }
}
