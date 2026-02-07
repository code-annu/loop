import 'package:equatable/equatable.dart';
import '../../../data/models/models.dart';

abstract class AlbumState extends Equatable {
  const AlbumState();

  @override
  List<Object?> get props => [];
}

class AlbumInitial extends AlbumState {}

class AlbumLoading extends AlbumState {}

class AlbumLoaded extends AlbumState {
  final AlbumModel album;

  const AlbumLoaded(this.album);

  @override
  List<Object?> get props => [album];
}

class AlbumError extends AlbumState {
  final String message;

  const AlbumError(this.message);

  @override
  List<Object?> get props => [message];
}
