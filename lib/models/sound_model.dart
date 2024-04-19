class SoundModel {
  final String? id;
  final String? name;
  final String? url;
  final int? duration;
  final bool? isActive;
  final int? size;
  final String? mimetype;
  final String? originalname;
  final String? packId;

  SoundModel({
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

  factory SoundModel.fromJson(Map<String, dynamic> json) {
    return SoundModel(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      url: json['url'] as String?,
      duration: json['duration'] as int?,
      isActive: json['is_active'] as bool?,
      size: json['size'] as int?,
      mimetype: json['mimetype'] as String?,
      originalname: json['originalname'] as String?,
      packId: json['pack_id'] as String?,
    );
  }
}
