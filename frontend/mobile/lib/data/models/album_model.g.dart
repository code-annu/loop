// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AlbumInfoModel _$AlbumInfoModelFromJson(Map<String, dynamic> json) =>
    AlbumInfoModel(id: json['id'] as String, title: json['title'] as String);

Map<String, dynamic> _$AlbumInfoModelToJson(AlbumInfoModel instance) =>
    <String, dynamic>{'id': instance.id, 'title': instance.title};

TrackInfoModel _$TrackInfoModelFromJson(Map<String, dynamic> json) =>
    TrackInfoModel(
      id: json['id'] as String,
      title: json['title'] as String,
      coverUrl: _readCoverUrl(json, 'coverUrl') as String?,
      trackUrl: _readTrackUrl(json, 'trackUrl') as String?,
      duration: (json['duration'] as num).toInt(),
    );

Map<String, dynamic> _$TrackInfoModelToJson(TrackInfoModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'coverUrl': instance.coverUrl,
      'trackUrl': instance.trackUrl,
      'duration': instance.duration,
    };

AlbumModel _$AlbumModelFromJson(Map<String, dynamic> json) => AlbumModel(
  id: json['id'] as String,
  title: json['title'] as String,
  coverUrl: _readCoverUrl(json, 'coverUrl') as String?,
  tracks:
      (json['tracks'] as List<dynamic>?)
          ?.map((e) => TrackInfoModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  artists:
      (json['artists'] as List<dynamic>?)
          ?.map((e) => ArtistModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$AlbumModelToJson(AlbumModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'coverUrl': instance.coverUrl,
      'tracks': instance.tracks,
      'artists': instance.artists,
    };
