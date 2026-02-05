import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';
import '../../core/errors/app_exception.dart';
import '../models/models.dart';

/// Album Repository Implementation
class AlbumRepository {
  final ApiClient _apiClient;

  AlbumRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient.instance;

  /// Get random albums
  Future<List<AlbumModel>> getRandomAlbums({int limit = 10}) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.randomAlbums,
        queryParameters: {'limit': limit.toString()},
      );

      final data = response.data as Map<String, dynamic>;
      if (data['status'] == 'success') {
        final List<dynamic> albumsJson = data['data'] as List<dynamic>;
        return albumsJson
            .map((json) => AlbumModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      throw ServerException('Failed to fetch albums');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Get album by ID
  Future<AlbumModel> getAlbumById(String id) async {
    try {
      final response = await _apiClient.get(ApiEndpoints.albumById(id));

      final data = response.data as Map<String, dynamic>;
      if (data['status'] == 'success') {
        return AlbumModel.fromJson(data['data'] as Map<String, dynamic>);
      }
      throw ServerException('Failed to fetch album');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  AppException _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return NetworkException('Connection timeout');
    }
    if (e.response?.statusCode == 404) {
      return NotFoundException('Album not found');
    }
    return ServerException(
      e.response?.data?['error']?['message'] ?? 'Server error',
      e.response?.statusCode,
    );
  }
}
