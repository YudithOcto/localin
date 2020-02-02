class NotificationModel {
  bool error;
  String message;
  List<NotificationDetailModel> data;

  NotificationModel({this.error, this.message, this.data});

  factory NotificationModel.fromJson(Map<String, dynamic> body) {
    List notification = body['data'];
    return NotificationModel(
        error: body['error'],
        message: body['message'],
        data: notification != null
            ? notification
                .map((value) => NotificationDetailModel.fromJson(value))
                .toList()
            : null);
  }

  NotificationModel.withError(String value)
      : error = true,
        message = value,
        data = null;
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
