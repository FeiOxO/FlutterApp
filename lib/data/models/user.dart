class User {
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

  factory User.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': String id,
        'username': String username,
        'email': String email,
        'avatar': String? avatar,
        'created_at': String? createdAtStr,
        'updated_at': String? updatedAtStr,
      } =>
        User(
          id: id,
          username: username,
          email: email,
          avatar: avatar,
          createdAt: createdAtStr != null ? DateTime.tryParse(createdAtStr) : null,
          updatedAt: updatedAtStr != null ? DateTime.tryParse(updatedAtStr) : null,
        ),
      _ => throw const FormatException('Failed to parse User'),
    };
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'email': email,
        'avatar': avatar,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
      };
}
