/// API Endpoints
class ApiEndpoints {
  ApiEndpoints._();

  // For Android emulator use 10.0.2.2, for iOS simulator use localhost
  // For real device, use your computer's IP address
  static const String baseUrl = 'https://loop-kq40.onrender.com/api/v1';

  // Tracks
  static const String tracks = '/tracks';
  static String trackById(String id) => '/tracks/$id';
  static const String randomTracks = '/tracks/random';

  // Albums
  static const String albums = '/albums';
  static String albumById(String id) => '/albums/$id';
  static const String randomAlbums = '/albums/random';

  // Artists
  static const String artists = '/artists';
  static String artistById(String id) => '/artists/$id';
  static const String randomArtists = '/artists/random';
}
