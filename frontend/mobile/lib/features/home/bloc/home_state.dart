import 'package:equatable/equatable.dart';
import '../../../data/models/models.dart';

/// Home Bloc States
abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class HomeInitial extends HomeState {
  const HomeInitial();
}

/// Loading state
class HomeLoading extends HomeState {
  const HomeLoading();
}

/// Loaded state with all data
class HomeLoaded extends HomeState {
  final List<TrackModel> quickPicks;
  final List<TrackModel> randomPicks;
  final List<AlbumModel> newAlbums;

  const HomeLoaded({
    this.quickPicks = const [],
    this.randomPicks = const [],
    this.newAlbums = const [],
  });

  @override
  List<Object?> get props => [quickPicks, randomPicks, newAlbums];

  HomeLoaded copyWith({
    List<TrackModel>? quickPicks,
    List<TrackModel>? randomPicks,
    List<AlbumModel>? newAlbums,
  }) {
    return HomeLoaded(
      quickPicks: quickPicks ?? this.quickPicks,
      randomPicks: randomPicks ?? this.randomPicks,
      newAlbums: newAlbums ?? this.newAlbums,
    );
  }
}

/// Error state
class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}
