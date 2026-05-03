class User {
  static const Object _unset = Object();

  final String id;
  final String username;
  final String email;
  final String? avatar;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User({
    required this.id,
    required this.username,
    required this.email,
    this.avatar,
    this.createdAt,
    this.updatedAt,
  });

  static String? _readString(dynamic v) {
    if (v == null) return null;
    if (v is String) return v;
    if (v is num) return v.toString();
    return v.toString();
  }

  static String _readId(dynamic v) {
    final s = _readString(v);
    if (s == null || s.isEmpty) {
      throw const FormatException('Failed to parse User: id is missing');
    }
    return s;
  }

  factory User.fromJson(Object? json) {
    if (json is! Map) {
      throw const FormatException('Failed to parse User');
    }
    final m = Map<String, dynamic>.from(json);
    try {
      final username = m['username'] as String?;
      if (username == null || username.isEmpty) {
        throw const FormatException('Failed to parse User: username is missing');
      }
      final email = m['email'] as String? ?? '';
      final createdStr =
          m['created_at'] as String? ?? m['createdAt'] as String?;
      final updatedStr =
          m['updated_at'] as String? ?? m['updatedAt'] as String?;

      return User(
        id: _readId(m['id']),
        username: username,
        email: email,
        avatar: _readString(m['avatar']),
        createdAt: createdStr != null ? DateTime.tryParse(createdStr) : null,
        updatedAt: updatedStr != null ? DateTime.tryParse(updatedStr) : null,
      );
    } on FormatException {
      rethrow;
    } catch (_) {
      throw const FormatException('Failed to parse User');
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'email': email,
        'avatar': avatar,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
      };

  User copyWith({
    Object? avatar = _unset,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id,
      username: username,
      email: email,
      avatar: identical(avatar, _unset) ? this.avatar : avatar as String?,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
