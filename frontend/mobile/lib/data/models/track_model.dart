import 'package:json_annotation/json_annotation.dart';
import 'artist_model.dart';
import 'album_model.dart';

part 'track_model.g.dart';

/// Track data model
@JsonSerializable()
class TrackModel {
  final String id;
  final String title;
  @JsonKey(name: 'coverUrl', readValue: _readCoverUrl)
  final String? coverUrl;
  @JsonKey(name: 'trackUrl', readValue: _readTrackUrl)
  final String? trackUrl;
  final int duration;
  final AlbumInfoModel? album;
  final List<ArtistModel> artists;

  const TrackModel({
    required this.id,
    required this.title,
    this.coverUrl,
    this.trackUrl,
    required this.duration,
    this.album,
    this.artists = const [],
  });

  factory TrackModel.fromJson(Map<String, dynamic> json) =>
      _$TrackModelFromJson(json);

  Map<String, dynamic> toJson() => _$TrackModelToJson(this);

  /// Get artist names as a comma-separated string
  String get artistNames => artists.map((a) => a.name).join(', ');

  /// Get formatted duration (MM:SS)
  String get formattedDuration {
    final minutes = duration ~/ 60;
    final seconds = duration % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}

Object? _readCoverUrl(Map<dynamic, dynamic> json, String key) {
  return json['coverUrl'] ?? json['cover_url'];
}

Object? _readTrackUrl(Map<dynamic, dynamic> json, String key) {
  return json['trackUrl'] ?? json['track_url'];
}
