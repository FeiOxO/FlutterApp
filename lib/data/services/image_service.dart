import 'package:dio/dio.dart';
import '../models/image_item.dart';
import '../models/api_response.dart';
import 'api_client.dart';

class ImageService {
  final ApiClient _client = ApiClient();

  Future<List<ImageItem>> getImages({String? collection}) async {
    final response = await _client.dio.get('/api/images');
    final apiResp = ApiResponse.fromJson(
      response.data as Map<String, dynamic>,
      (d) => (d as List).map((e) => ImageItem.fromJson(e)).toList(),
    );
    if (!apiResp.success) throw ImageException(message: apiResp.message);
    return apiResp.data as List<ImageItem>;
  }

  Future<List<({String collection, int count})>> getCollections() async {
    return [];
  }

  Future<ImageItem> upload({required String filePath}) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath),
    });
    final response = await _client.dio.post(
      '/api/images/upload',
      data: formData,
      options: Options(
        contentType: 'multipart/form-data',
        receiveTimeout: const Duration(seconds: 30),
      ),
    );
    final apiResp = ApiResponse.fromJson(
      response.data as Map<String, dynamic>,
      (d) => ImageItem.fromJson(d),
    );
    if (!apiResp.success) throw ImageException(message: apiResp.message);
    return apiResp.data!;
  }

  Future<ImageItem> updateCollection(String imageId, String? collection) async {
    throw ImageException(
      message: '当前服务端未提供图集分类接口（无 PATCH /api/images/:id/collection）',
    );
  }

  Future<void> delete(String imageId) async {
    final response = await _client.dio.delete('/api/images/$imageId');
    final apiResp = ApiResponse.fromJson(
      response.data as Map<String, dynamic>,
      null,
    );
    if (!apiResp.success) throw ImageException(message: apiResp.message);
  }
}

class ImageException implements Exception {
  final String message;
  ImageException({required this.message});

  @override
  String toString() => message;
}
