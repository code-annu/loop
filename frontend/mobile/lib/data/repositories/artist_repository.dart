import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';
import '../../core/errors/app_exception.dart';
import '../models/models.dart';

/// Artist Repository Implementation
class ArtistRepository {
  final ApiClient _apiClient;

  ArtistRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient.instance;

  /// Get random artists
  Future<List<ArtistModel>> getRandomArtists({int limit = 10}) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.randomArtists,
        queryParameters: {'limit': limit.toString()},
      );

      final data = response.data as Map<String, dynamic>;
      if (data['status'] == 'success') {
        final List<dynamic> artistsJson = data['data'] as List<dynamic>;
        return artistsJson
            .map((json) => ArtistModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      throw ServerException('Failed to fetch artists');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Get artist by ID
  Future<ArtistModel> getArtistById(String id) async {
    try {
      final response = await _apiClient.get(ApiEndpoints.artistById(id));

      final data = response.data as Map<String, dynamic>;
      if (data['status'] == 'success') {
        return ArtistModel.fromJson(data['data'] as Map<String, dynamic>);
      }
      throw ServerException('Failed to fetch artist');
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
      return NotFoundException('Artist not found');
    }
    return ServerException(
      e.response?.data?['error']?['message'] ?? 'Server error',
      e.response?.statusCode,
    );
  }
}
