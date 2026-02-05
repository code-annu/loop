// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AlbumInfoModel _$AlbumInfoModelFromJson(Map<String, dynamic> json) =>
    AlbumInfoModel(
      id: json['id'] as String,
      title: json['title'] as String,
    );

Map<String, dynamic> _$AlbumInfoModelToJson(AlbumInfoModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
    };

TrackInfoModel _$TrackInfoModelFromJson(Map<String, dynamic> json) =>
    TrackInfoModel(
      id: json['id'] as String,
      title: json['title'] as String,
      coverUrl: json['cover_url'] as String?,
      trackUrl: json['track_url'] as String?,
      duration: (json['duration'] as num).toInt(),
    );

Map<String, dynamic> _$TrackInfoModelToJson(TrackInfoModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'cover_url': instance.coverUrl,
      'track_url': instance.trackUrl,
      'duration': instance.duration,
    };

AlbumModel _$AlbumModelFromJson(Map<String, dynamic> json) => AlbumModel(
      id: json['id'] as String,
      title: json['title'] as String,
      coverUrl: json['cover_url'] as String?,
      tracks: (json['tracks'] as List<dynamic>?)
              ?.map((e) => TrackInfoModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      artists: (json['artists'] as List<dynamic>?)
              ?.map((e) => ArtistModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$AlbumModelToJson(AlbumModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'cover_url': instance.coverUrl,
      'tracks': instance.tracks.map((e) => e.toJson()).toList(),
      'artists': instance.artists.map((e) => e.toJson()).toList(),
    };
