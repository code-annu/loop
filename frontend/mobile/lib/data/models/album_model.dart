import 'package:json_annotation/json_annotation.dart';
import 'artist_model.dart';

part 'album_model.g.dart';

/// Album info for track response
@JsonSerializable()
class AlbumInfoModel {
  final String id;
  final String title;

  const AlbumInfoModel({required this.id, required this.title});

  factory AlbumInfoModel.fromJson(Map<String, dynamic> json) =>
      _$AlbumInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$AlbumInfoModelToJson(this);
}

/// Track info for album response
@JsonSerializable()
class TrackInfoModel {
  final String id;
  final String title;
  @JsonKey(name: 'coverUrl', readValue: _readCoverUrl)
  final String? coverUrl;
  @JsonKey(name: 'trackUrl', readValue: _readTrackUrl)
  final String? trackUrl;
  final int duration;

  const TrackInfoModel({
    required this.id,
    required this.title,
    this.coverUrl,
    this.trackUrl,
    required this.duration,
  });

  factory TrackInfoModel.fromJson(Map<String, dynamic> json) =>
      _$TrackInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$TrackInfoModelToJson(this);
}

/// Full Album model with tracks and artists
@JsonSerializable()
class AlbumModel {
  final String id;
  final String title;
  @JsonKey(name: 'coverUrl', readValue: _readCoverUrl)
  final String? coverUrl;
  final List<TrackInfoModel> tracks;
  final List<ArtistModel> artists;

  const AlbumModel({
    required this.id,
    required this.title,
    this.coverUrl,
    this.tracks = const [],
    this.artists = const [],
  });

  factory AlbumModel.fromJson(Map<String, dynamic> json) =>
      _$AlbumModelFromJson(json);

  Map<String, dynamic> toJson() => _$AlbumModelToJson(this);

  /// Get artist names as a comma-separated string
  String get artistNames => artists.map((a) => a.name).join(', ');
}

Object? _readCoverUrl(Map<dynamic, dynamic> json, String key) {
  return json['coverUrl'] ?? json['cover_url'];
}

Object? _readTrackUrl(Map<dynamic, dynamic> json, String key) {
  return json['trackUrl'] ?? json['track_url'];
}
