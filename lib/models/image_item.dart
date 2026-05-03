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
    return switch (json) {
      {
        'id': String id,
        'user_id': String? userId,
        'filename': String? filename,
        'original_name': String? originalName,
        'url': String url,
        'is_default': bool? isDefault,
        'collection': String? collection,
        'created_at': String? createdAtStr,
      } =>
        ImageItem(
          id: id,
          userId: userId ?? '',
          filename: filename ?? '',
          originalName: originalName ?? '',
          url: url,
          isDefault: isDefault ?? false,
          collection: collection,
          createdAt: createdAtStr != null ? DateTime.tryParse(createdAtStr) : null,
        ),
      _ => throw const FormatException('Failed to parse ImageItem'),
    };
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
