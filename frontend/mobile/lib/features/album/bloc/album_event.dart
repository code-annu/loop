import 'package:equatable/equatable.dart';

abstract class AlbumEvent extends Equatable {
  const AlbumEvent();

  @override
  List<Object?> get props => [];
}

class LoadAlbum extends AlbumEvent {
  final String albumId;

  const LoadAlbum(this.albumId);

  @override
  List<Object?> get props => [albumId];
}
