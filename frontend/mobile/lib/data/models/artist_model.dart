import 'package:json_annotation/json_annotation.dart';

part 'artist_model.g.dart';

/// Artist data model
@JsonSerializable()
class ArtistModel {
  final String id;
  final String name;
  @JsonKey(name: 'profile_url')
  final String? profileUrl;

  const ArtistModel({
    required this.id,
    required this.name,
    this.profileUrl,
  });

  factory ArtistModel.fromJson(Map<String, dynamic> json) =>
      _$ArtistModelFromJson(json);

  Map<String, dynamic> toJson() => _$ArtistModelToJson(this);
}
