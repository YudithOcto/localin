import 'dart:convert';

import 'package:localin/model/community/community_discover_type.dart';
import 'package:localin/model/community/community_member_detail.dart';

class CommunityDetail implements CommunityDiscoverType {
  String id;
  String slug;
  String name;
  String category;
  String categoryName;
  String description;
  String address;
  String logo;
  String logoUrl;
  int imageCount;
  int follower;
  String ranting;
  String status;
  String createBy;
  String createdAt;
  String updatedAt;
  String deletedAt;
  String cover;
  String latitude;
  String longitude;
  bool isJoin;
  bool isAdmin;
  String joinStatus;
  int totalMember;
  bool loginStatusType;
  String communityType;
  String transactionId;
  Feature features;
  List<CommunityMemberDetail> listMember;

  CommunityDetail({
    this.id,
    this.slug,
    this.name,
    this.category,
    this.description,
    this.address,
    this.logo,
    this.ranting,
    this.status,
    this.createBy,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.cover,
    this.latitude,
    this.longitude,
    this.categoryName,
    this.follower,
    this.imageCount,
    this.logoUrl,
    this.isJoin = false,
    this.totalMember,
    this.loginStatusType,
    this.communityType,
    this.transactionId,
    this.features,
    this.isAdmin,
    this.joinStatus,
    this.listMember,
  });

  factory CommunityDetail.fromJson(Map<String, dynamic> body) {
    return CommunityDetail(
      id: body['id'],
      slug: body['slug'],
      name: body['nama'],
      category: body['kategori'],
      description: body['deskripsi'],
      address: body['address'],
      logo: body['logo'],
      ranting: body['ranting'],
      status: body['status'],
      createBy: body['created_by'],
      createdAt: body['created_at'],
      updatedAt: body['updated_at'],
      deletedAt: body['deleted_at'],
      cover: body['sampul'],
      latitude: body['latitude'],
      longitude: body['longitude'],
      categoryName: body['kategori_nama'],
      follower: body['follower'],
      imageCount: body['image_count'],
      logoUrl: body['logo_url'],
      isJoin: body['is_join'],
      totalMember: body['total_member'],
      loginStatusType: body['is_admin'] ?? false,
      communityType: body['type'],
      transactionId: body['transaksi_id'] ?? null,
      isAdmin: body['is_admin'] == null ? false : body['is_admin'],
      joinStatus: body['status_join'] ?? '',
      listMember: body['list_anggota'] == null
          ? []
          : List<CommunityMemberDetail>.from(body['list_anggota']
              .map((e) => CommunityMemberDetail.fromJson(e))),
      features:
          body['feature'] == null ? null : Feature.fromMap(body["feature"]),
    );
  }
}

class Feature {
  Feature({
    this.chat,
    this.event,
    this.createPost,
  });

  final bool chat;
  final bool event;
  final bool createPost;

  factory Feature.fromJson(String str) => Feature.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Feature.fromMap(Map<String, dynamic> json) => Feature(
        chat: json["chat"],
        event: json["event"],
        createPost: json["create_post"],
      );

  Map<String, dynamic> toMap() => {
        "chat": chat,
        "event": event,
        "create_post": createPost,
      };
}
