import 'package:localin/model/community/community_event_member_response.dart';

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
        data: json['data'] == null
            ? null
            : EventResponseData.fromMap(json["data"]),
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
    this.createdName,
    this.createdImageProfile,
    this.isVerifyCreator,
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
    this.memberGoingCount,
    this.memberList,
    this.userAttendStatus,
    this.latitude,
    this.longitude,
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
  final String createdName;
  final bool isVerifyCreator;
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
  final int memberGoingCount;
  final String userAttendStatus;
  final List<EventMemberDetail> memberList;
  final String createdImageProfile;
  final String latitude;
  final String longitude;

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
          memberGoingCount: json['count_hadir'] ?? 0,
          memberList: json['attendees_going'] == null
              ? null
              : List<EventMemberDetail>.from(
                  json['attendees_going'].map(
                    (e) => EventMemberDetail.fromJson(e),
                  ),
                ),
          createdName: json['created_name'] ?? '',
          createdImageProfile: json['created_image_profile'] ?? '',
          userAttendStatus: json['status_hadir'] ?? '',
          latitude: json['latitude'] == null ? null : json['latitude'],
          longitude: json['longitude'] == null ? null : json['longitude'],
          isVerifyCreator: json['verified'] == null
              ? false
              : json['verified'] == 1 ? true : false);
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
