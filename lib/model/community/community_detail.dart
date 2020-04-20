class CommunityDetail {
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
  int totalMember;

  CommunityDetail(
      {this.id,
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
      this.isJoin,
      this.totalMember});

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
    );
  }
}
