import 'package:dio/dio.dart';
import '../models/image_item.dart';
import '../models/api_response.dart';
import 'api_client.dart';

class ImageService {
  final ApiClient _client = ApiClient();

  Future<List<ImageItem>> getImages({String? collection}) async {
    final query = <String, dynamic>{};
    if (collection != null && collection.isNotEmpty) {
      query['collection'] = collection;
    }
    final response = await _client.dio.get(
      '/api/images',
      queryParameters: query.isEmpty ? null : query,
    );
    final apiResp = ApiResponse.fromJson(
      response.data as Map<String, dynamic>,
      (d) => (d as List).map((e) => ImageItem.fromJson(e)).toList(),
    );
    if (!apiResp.success) throw ImageException(message: apiResp.message);
    return apiResp.data as List<ImageItem>;
  }

  Future<List<({String collection, int count})>> getCollections() async {
    final response = await _client.dio.get('/api/images/collections');
    final apiResp = ApiResponse.fromJson(
      response.data as Map<String, dynamic>,
      (d) => (d as List).map((e) {
        final m = Map<String, dynamic>.from(e as Map);
        final countRaw = m['count'];
        final count = countRaw is int
            ? countRaw
            : (countRaw is num ? countRaw.toInt() : int.tryParse('$countRaw') ?? 0);
        return (collection: m['collection'] as String? ?? '', count: count);
      }).toList(),
    );
    if (!apiResp.success) throw ImageException(message: apiResp.message);
    return apiResp.data as List<({String collection, int count})>;
  }

  Future<ImageItem> upload({
    required String filePath,
    String? collection,
  }) async {
    final map = <String, dynamic>{
      'file': await MultipartFile.fromFile(filePath),
    };
    if (collection != null && collection.isNotEmpty) {
      map['collection'] = collection;
    }
    final formData = FormData.fromMap(map);
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
    final response = await _client.dio.patch(
      '/api/images/$imageId/collection',
      data: {'collection': collection},
    );
    final apiResp = ApiResponse.fromJson(
      response.data as Map<String, dynamic>,
      (d) => ImageItem.fromJson(d),
    );
    if (!apiResp.success) throw ImageException(message: apiResp.message);
    return apiResp.data!;
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
