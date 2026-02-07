import 'package:equatable/equatable.dart';
import '../../../data/models/models.dart';

enum HomeSectionStatus { initial, loading, loaded, error }

/// Home Bloc State
class HomeState extends Equatable {
  final HomeSectionStatus quickPicksStatus;
  final List<TrackModel> quickPicks;

  final HomeSectionStatus randomPicksStatus;
  final List<TrackModel> randomPicks;

  final HomeSectionStatus newAlbumsStatus;
  final List<AlbumModel> newAlbums;

  final HomeSectionStatus tracksStatus;
  final List<TrackModel> tracks;

  final String? errorMessage;

  const HomeState({
    this.quickPicksStatus = HomeSectionStatus.initial,
    this.quickPicks = const [],
    this.randomPicksStatus = HomeSectionStatus.initial,
    this.randomPicks = const [],
    this.newAlbumsStatus = HomeSectionStatus.initial,
    this.newAlbums = const [],
    this.tracksStatus = HomeSectionStatus.initial,
    this.tracks = const [],
    this.errorMessage,
  });

  HomeState copyWith({
    HomeSectionStatus? quickPicksStatus,
    List<TrackModel>? quickPicks,
    HomeSectionStatus? randomPicksStatus,
    List<TrackModel>? randomPicks,
    HomeSectionStatus? newAlbumsStatus,
    List<AlbumModel>? newAlbums,
    HomeSectionStatus? tracksStatus,
    List<TrackModel>? tracks,
    String? errorMessage,
  }) {
    return HomeState(
      quickPicksStatus: quickPicksStatus ?? this.quickPicksStatus,
      quickPicks: quickPicks ?? this.quickPicks,
      randomPicksStatus: randomPicksStatus ?? this.randomPicksStatus,
      randomPicks: randomPicks ?? this.randomPicks,
      newAlbumsStatus: newAlbumsStatus ?? this.newAlbumsStatus,
      newAlbums: newAlbums ?? this.newAlbums,
      tracksStatus: tracksStatus ?? this.tracksStatus,
      tracks: tracks ?? this.tracks,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    quickPicksStatus,
    quickPicks,
    randomPicksStatus,
    randomPicks,
    newAlbumsStatus,
    newAlbums,
    tracksStatus,
    tracks,
    errorMessage,
  ];
}
