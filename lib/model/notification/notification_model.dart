class NotificationModelResponse {
  bool error;
  String message;
  int total;
  NotificationModel model;

  NotificationModelResponse({this.error, this.message, this.model, this.total});

  factory NotificationModelResponse.fromJson(Map<String, dynamic> body) {
    return NotificationModelResponse(
      error: body['error'],
      total: body['data']['paging']['total'],
      message: body['message'],
      model: NotificationModel.fromJson(
        body['data'],
      ),
    );
  }

  NotificationModelResponse.withError(String value)
      : error = true,
        message = value,
        model = null;
}

class NotificationModel {
  List<NotificationDetailModel> data;
  int total;

  NotificationModel({this.data, this.total});

  factory NotificationModel.fromJson(Map<String, dynamic> body) {
    List notification = body['data'];
    return NotificationModel(
        data: notification != null
            ? notification
                .map((value) => NotificationDetailModel.fromJson(value))
                .toList()
            : null,
        total: body['paging']['total']);
  }
}

class NotificationDetailModel {
  String id;
  String memberId;
  String type;
  String typeId;
  String message;
  String icon;
  int isRead;
  String createdAt;
  String updatedAt;

  NotificationDetailModel(
      {this.id,
      this.memberId,
      this.type,
      this.typeId,
      this.message,
      this.icon,
      this.isRead,
      this.createdAt,
      this.updatedAt});

  factory NotificationDetailModel.fromJson(Map<String, dynamic> body) {
    return NotificationDetailModel(
        id: body['id'],
        memberId: body['member_id'],
        type: body['tipe'],
        typeId: body['tipe_id'],
        message: body['message'],
        icon: body['icon'],
        isRead: body['is_read'],
        createdAt: body['created_at'],
        updatedAt: body['updated_at']);
  }
}
