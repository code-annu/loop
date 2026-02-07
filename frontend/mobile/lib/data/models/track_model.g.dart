// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrackModel _$TrackModelFromJson(Map<String, dynamic> json) => TrackModel(
  id: json['id'] as String,
  title: json['title'] as String,
  coverUrl: _readCoverUrl(json, 'coverUrl') as String?,
  trackUrl: _readTrackUrl(json, 'trackUrl') as String?,
  duration: (json['duration'] as num).toInt(),
  album:
      json['album'] == null
          ? null
          : AlbumInfoModel.fromJson(json['album'] as Map<String, dynamic>),
  artists:
      (json['artists'] as List<dynamic>?)
          ?.map((e) => ArtistModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$TrackModelToJson(TrackModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'coverUrl': instance.coverUrl,
      'trackUrl': instance.trackUrl,
      'duration': instance.duration,
      'album': instance.album,
      'artists': instance.artists,
    };
