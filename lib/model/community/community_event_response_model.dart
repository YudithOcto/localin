class CommunityEventResponseModel {
  CommunityEventResponseModel({
    this.error,
    this.message,
    this.data,
    this.total,
    this.dataList,
  });

  final bool error;
  final int total;
  final String message;
  final EventResponseData data;
  final List<EventResponseData> dataList;

  factory CommunityEventResponseModel.fromMap(Map<String, dynamic> json) =>
      CommunityEventResponseModel(
        error: json["error"],
        message: json["message"],
        data: EventResponseData.fromMap(json["data"]) ?? null,
      );

  factory CommunityEventResponseModel.fromMapList(Map<String, dynamic> json) =>
      CommunityEventResponseModel(
        error: json["error"],
        message: json["message"],
        total: json['paging']['total'],
        dataList: List<EventResponseData>.from(
            json['data'].map((e) => EventResponseData.fromMap(e))),
      );

  CommunityEventResponseModel.withError(String value)
      : error = true,
        message = value,
        data = null,
        total = 0,
        dataList = [];
}

class EventResponseData {
  EventResponseData({
    this.id,
    this.title,
    this.description,
    this.startDate,
    this.endDate,
    this.startTime,
    this.endTime,
    this.address,
    this.type,
    this.attachmentType,
    this.communityId,
    this.createdBy,
    this.audience,
    this.status,
    this.updatedAt,
    this.createdAt,
    this.attachment,
    this.isOnline,
    this.communityName,
    this.communitySlug,
    this.communityLogo,
    this.communityJoinStatus,
  });

  final String id;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final String startTime;
  final String endTime;
  final String address;
  final String type;
  final String attachmentType;
  final String communityId;
  final String createdBy;
  final int audience;
  final String status;
  final DateTime updatedAt;
  final DateTime createdAt;
  final List<EventAttachment> attachment;
  final bool isOnline;
  final String communityName;
  final String communitySlug;
  final String communityLogo;
  final String communityJoinStatus;

  factory EventResponseData.fromMap(Map<String, dynamic> json) =>
      EventResponseData(
        id: json["id"],
        title: json["judul"],
        description: json["deskripsi"],
        startDate: DateTime.parse(json["start_date"]),
        endDate: DateTime.parse(json["end_date"]),
        startTime: json["start_time"],
        endTime: json["end_time"],
        address: json["alamat"],
        type: json["tipe"],
        attachmentType: json["lampiran_tipe"],
        communityId: json["komunitas_id"],
        createdBy: json["created_by"],
        audience: json["peserta"],
        status: json["status"],
        updatedAt: DateTime.parse(json["updated_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        attachment: json['lampiran'] == null
            ? []
            : List<EventAttachment>.from(
                json["lampiran"].map((x) => EventAttachment.fromMap(x))),
        isOnline: json['is_online'] == 1 ? true : false,
        communityName: json['komunitas_nama'],
        communityLogo: json['komunitas_logo'],
        communitySlug: json['komunitas_slug'],
        communityJoinStatus: json['status_join_komunitas'],
      );
}

class EventAttachment {
  EventAttachment({
    this.attachmentId,
    this.commentId,
    this.attachment,
    this.type,
  });

  final String attachmentId;
  final String commentId;
  final String attachment;
  final String type;

  factory EventAttachment.fromMap(Map<String, dynamic> json) => EventAttachment(
        attachmentId: json["lampiran_id"],
        commentId: json["komentar_id"] ?? null,
        attachment: json['gambar'] != null
            ? json['gambar']
            : json["lampiran"] != null ? json['lampiran'] : null,
        type: json["type"] ?? null,
      );
}
