class CommunityDetail {
  String id;
  String slug;
  String name;
  String category;
  String description;
  String logo;
  String ranting;
  String status;
  String createBy;
  String createdAt;
  String updatedAt;
  String deletedAt;
  String cover;
  double latitude;
  double longitude;

  CommunityDetail(
      {this.id,
      this.slug,
      this.name,
      this.category,
      this.description,
      this.logo,
      this.ranting,
      this.status,
      this.createBy,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.cover,
      this.latitude,
      this.longitude});

  factory CommunityDetail.fromJson(Map<String, dynamic> body) {
    return CommunityDetail(
      id: body['id'],
      slug: body['slug'],
      name: body['nama'],
      category: body['kategori'],
      description: body['deskripsi'],
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
    );
  }
}
