import 'package:flutter_test/flutter_test.dart';
import 'package:login_flutter/data/models/user.dart';
import 'package:login_flutter/data/models/image_item.dart';
import 'package:login_flutter/data/models/api_response.dart';

void main() {
  group('User model', () {
    test('fromJson parses valid JSON correctly', () {
      final json = {
        'id': '550e8400-e29b-41d4-a716-446655440000',
        'username': 'asumi',
        'email': 'asumi@example.com',
        'avatar': '/uploads/images/avatar.jpg',
        'created_at': '2026-05-01T12:00:00Z',
        'updated_at': '2026-05-02T12:00:00Z',
      };

      final user = User.fromJson(json);
      expect(user.id, '550e8400-e29b-41d4-a716-446655440000');
      expect(user.username, 'asumi');
      expect(user.email, 'asumi@example.com');
      expect(user.avatar, '/uploads/images/avatar.jpg');
      expect(user.createdAt, isNotNull);
      expect(user.updatedAt, isNotNull);
    });

    test('fromJson handles missing optional fields', () {
      final json = {
        'id': '550e8400-e29b-41d4-a716-446655440000',
        'username': 'asumi',
        'email': 'asumi@example.com',
        'avatar': null,
        'created_at': null,
        'updated_at': null,
      };

      final user = User.fromJson(json);
      expect(user.avatar, isNull);
      expect(user.createdAt, isNull);
      expect(user.updatedAt, isNull);
    });

    test('fromJson throws on invalid JSON', () {
      expect(
        () => User.fromJson({'invalid': 'data'}),
        throwsA(isA<FormatException>()),
      );
    });

    test('toJson produces correct output', () {
      final user = User(
        id: '550e8400-e29b-41d4-a716-446655440000',
        username: 'asumi',
        email: 'asumi@example.com',
      );

      final json = user.toJson();
      expect(json['id'], '550e8400-e29b-41d4-a716-446655440000');
      expect(json['username'], 'asumi');
      expect(json['email'], 'asumi@example.com');
    });
  });

  group('ImageItem model', () {
    test('fromJson parses valid JSON correctly', () {
      final json = {
        'id': '660e8400-e29b-41d4-a716-446655440001',
        'user_id': '550e8400-e29b-41d4-a716-446655440000',
        'filename': 'abc123.jpg',
        'original_name': 'photo.jpg',
        'url': '/uploads/images/abc123.jpg',
        'is_default': false,
        'collection': 'asumi',
        'created_at': '2026-05-01T12:00:00Z',
      };

      final image = ImageItem.fromJson(json);
      expect(image.id, '660e8400-e29b-41d4-a716-446655440001');
      expect(image.collection, 'asumi');
      expect(image.isDefault, false);
      expect(image.url, '/uploads/images/abc123.jpg');
    });

    test('fromJson handles null collection', () {
      final json = {
        'id': '660e8400-e29b-41d4-a716-446655440001',
        'url': '/uploads/images/abc123.jpg',
      };

      final image = ImageItem.fromJson(json);
      expect(image.collection, isNull);
      expect(image.isDefault, false);
    });

    test('copyWith creates modified copy', () {
      final image = ImageItem(
        id: '660e8400-e29b-41d4-a716-446655440001',
        userId: 'user1',
        filename: 'test.jpg',
        originalName: 'test.jpg',
        url: '/uploads/images/test.jpg',
        collection: 'asumi',
      );

      final modified = image.copyWith(collection: 'sister');
      expect(modified.id, image.id);
      expect(modified.collection, 'sister');
      expect(image.collection, 'asumi'); // original unchanged
    });
  });

  group('ApiResponse model', () {
    test('parses successful response with data', () {
      final json = {
        'success': true,
        'message': 'OK',
        'data': {'token': 'abc123'},
      };

      final response = ApiResponse.fromJson(
        json,
        (d) => (d as Map<String, dynamic>)['token'] as String,
      );
      expect(response.success, true);
      expect(response.data, 'abc123');
      expect(response.errors, isNull);
    });

    test('parses error response with field errors', () {
      final json = {
        'success': false,
        'message': 'Validation failed',
        'errors': [
          {'field': 'body.username', 'message': '用户名已存在'},
        ],
      };

      final response = ApiResponse.fromJson(json, null);
      expect(response.success, false);
      expect(response.errors, isNotEmpty);
      expect(response.errors!.first.field, 'body.username');
      expect(response.errors!.first.message, '用户名已存在');
    });

    test('parses error response without data', () {
      final json = {
        'success': false,
        'message': 'Invalid credentials',
      };

      final response = ApiResponse.fromJson(json, null);
      expect(response.success, false);
      expect(response.data, isNull);
      expect(response.errors, isNull);
    });
  });
}
