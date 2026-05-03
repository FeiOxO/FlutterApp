class ImageItem {
  final String id;
  final String userId;
  final String filename;
  final String originalName;
  final String url;
  final bool isDefault;
  final String? collection;
  final DateTime? createdAt;

  ImageItem({
    required this.id,
    required this.userId,
    required this.filename,
    required this.originalName,
    required this.url,
    this.isDefault = false,
    this.collection,
    this.createdAt,
  });

  factory ImageItem.fromJson(Map<String, dynamic> json) {
    return ImageItem(
      id: json['id'] as String,
      userId: json['user_id'] as String? ?? '',
      filename: json['filename'] as String? ?? '',
      originalName: json['original_name'] as String? ?? '',
      url: json['url'] as String,
      isDefault: json['is_default'] as bool? ?? false,
      collection: json['collection'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'filename': filename,
        'original_name': originalName,
        'url': url,
        'is_default': isDefault,
        'collection': collection,
        'created_at': createdAt?.toIso8601String(),
      };

  ImageItem copyWith({String? collection}) {
    return ImageItem(
      id: id,
      userId: userId,
      filename: filename,
      originalName: originalName,
      url: url,
      isDefault: isDefault,
      collection: collection ?? this.collection,
      createdAt: createdAt,
    );
  }
}
