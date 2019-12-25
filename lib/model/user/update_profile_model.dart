class UpdateProfileModel {
  String message;
  String error;

  UpdateProfileModel({this.message, this.error});

  UpdateProfileModel.fromJson(Map<String, dynamic> body)
      : message = body['message'],
        error = '';

  UpdateProfileModel.errorJson(String messageError)
      : error = messageError,
        message = '';
}
