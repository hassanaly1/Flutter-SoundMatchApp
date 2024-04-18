class SoundPackModel {
  final String id;
  final String packName;
  final String packImage;
  final bool isPaid;
  final bool isActive;
  final int price;
  final int discountedPrice;
  final List<String> sounds;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int version;

  SoundPackModel({
    required this.id,
    required this.packName,
    required this.packImage,
    required this.isPaid,
    required this.isActive,
    required this.price,
    required this.discountedPrice,
    required this.sounds,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
  });

  // Method to convert JSON to SoundPackModel
  factory SoundPackModel.fromJson(Map<String, dynamic> json) {
    return SoundPackModel(
      id: json['_id'] ?? '',
      packName: json['name'] ?? '',
      packImage: json['url'] ?? '',
      isPaid: json['is_paid'] ?? false,
      isActive: json['is_active'] ?? false,
      price: json['price'] ?? 0,
      discountedPrice: json['discounted_price'] ?? 0,
      sounds: List<String>.from(json['sounds'] ?? []),
      createdAt: DateTime.parse(json['created_at'] ?? ''),
      updatedAt: DateTime.parse(json['updated_at'] ?? ''),
      version: json['__v'] ?? 0, // The version number
    );
  }
}
