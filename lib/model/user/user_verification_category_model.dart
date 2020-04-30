class UserVerificationCategoryModel {
  bool error;
  String message;
  List<UserCategoryDetailModel> data;

  UserVerificationCategoryModel({
    this.error,
    this.message,
    this.data,
  });

  factory UserVerificationCategoryModel.fromJson(Map<String, dynamic> json) =>
      UserVerificationCategoryModel(
        error: json["error"],
        message: json["message"],
        data: List<UserCategoryDetailModel>.from(
            json["data"].map((x) => UserCategoryDetailModel.fromJson(x))),
      );

  UserVerificationCategoryModel.withError(String value)
      : error = true,
        message = value,
        data = null;

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class UserCategoryDetailModel {
  String id;
  String category;

  UserCategoryDetailModel({
    this.id,
    this.category,
  });

  factory UserCategoryDetailModel.fromJson(Map<String, dynamic> json) =>
      UserCategoryDetailModel(
        id: json["id"],
        category: json["kategori"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "kategori": category,
      };
}
