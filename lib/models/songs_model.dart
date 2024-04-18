class SongsModel {
  final String? id;
  final String? name;
  final String? url;
  final int? duration;
  final bool? isActive;
  final int? size;
  final String? mimetype;
  final String? originalname;
  final String? packId;

  SongsModel({
    this.id,
    this.name,
    this.url,
    this.duration,
    this.isActive,
    this.size,
    this.mimetype,
    this.originalname,
    this.packId,
  });

  // Factory method to create a SongsModel instance from JSON
  factory SongsModel.fromJson(Map<String, dynamic> json) {
    return SongsModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      url: json['url'] ?? '',
      duration: json['duration'] ?? 0,
      isActive: json['is_active'] ?? false,
      size: json['size'] ?? 0,
      mimetype: json['mimetype'] ?? '',
      originalname: json['originalname'] ?? '',
      packId: json['pack_id'] ?? '',
    );
  }
}
