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

  static String _readId(dynamic v) {
    if (v == null) throw const FormatException('Failed to parse ImageItem: id');
    if (v is String) return v;
    if (v is num) return v.toString();
    return v.toString();
  }

  static String? _readString(dynamic v) {
    if (v == null) return null;
    if (v is String) return v;
    return v.toString();
  }

  static bool _readBool(dynamic v) {
    if (v is bool) return v;
    if (v is num) return v != 0;
    return false;
  }

  factory ImageItem.fromJson(Object? json) {
    if (json is! Map) {
      throw const FormatException('Failed to parse ImageItem');
    }
    final m = Map<String, dynamic>.from(json);
    try {
      final url = m['url'] as String?;
      if (url == null || url.isEmpty) {
        throw const FormatException('Failed to parse ImageItem: url');
      }
      final createdStr =
          m['created_at'] as String? ?? m['createdAt'] as String?;
      return ImageItem(
        id: _readId(m['id']),
        userId: _readString(m['user_id'] ?? m['userId']) ?? '',
        filename: _readString(m['filename']) ?? '',
        originalName:
            _readString(m['original_name'] ?? m['originalName']) ?? '',
        url: url,
        isDefault: _readBool(m['is_default'] ?? m['isDefault']),
        collection: _readString(m['collection']),
        createdAt: createdStr != null ? DateTime.tryParse(createdStr) : null,
      );
    } on FormatException {
      rethrow;
    } catch (_) {
      throw const FormatException('Failed to parse ImageItem');
    }
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
