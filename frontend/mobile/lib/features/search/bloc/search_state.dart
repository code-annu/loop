import 'package:equatable/equatable.dart';
import '../../../data/models/models.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<TrackModel> tracks;
  final List<AlbumModel> albums;

  const SearchLoaded({this.tracks = const [], this.albums = const []});

  @override
  List<Object?> get props => [tracks, albums];
}

class SearchError extends SearchState {
  final String message;

  const SearchError(this.message);

  @override
  List<Object?> get props => [message];
}
