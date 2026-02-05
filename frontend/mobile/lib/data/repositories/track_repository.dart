import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';
import '../../core/errors/app_exception.dart';
import '../models/models.dart';

/// Track Repository Implementation
class TrackRepository {
  final ApiClient _apiClient;

  TrackRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient.instance;

  /// Get random tracks
  Future<List<TrackModel>> getRandomTracks({int limit = 10}) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.randomTracks,
        queryParameters: {'limit': limit.toString()},
      );

      final data = response.data as Map<String, dynamic>;
      if (data['status'] == 'success') {
        final List<dynamic> tracksJson = data['data'] as List<dynamic>;
        return tracksJson
            .map((json) => TrackModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      throw ServerException('Failed to fetch tracks');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Get track by ID
  Future<TrackModel> getTrackById(String id) async {
    try {
      final response = await _apiClient.get(ApiEndpoints.trackById(id));

      final data = response.data as Map<String, dynamic>;
      if (data['status'] == 'success') {
        return TrackModel.fromJson(data['data'] as Map<String, dynamic>);
      }
      throw ServerException('Failed to fetch track');
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
      return NotFoundException('Track not found');
    }
    return ServerException(
      e.response?.data?['error']?['message'] ?? 'Server error',
      e.response?.statusCode,
    );
  }
}
