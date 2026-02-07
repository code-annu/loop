import 'package:equatable/equatable.dart';

/// Home Bloc Events
abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

/// Fetch all home data (triggers individual fetches)
class FetchHomeData extends HomeEvent {
  const FetchHomeData();
}

/// Fetch only quick picks section
class FetchQuickPicks extends HomeEvent {
  const FetchQuickPicks();
}

/// Fetch only random picks section
class FetchRandomPicks extends HomeEvent {
  const FetchRandomPicks();
}

/// Fetch only new albums section
class FetchNewAlbums extends HomeEvent {
  const FetchNewAlbums();
}

/// Fetch tracks section
class FetchTracks extends HomeEvent {
  const FetchTracks();
}
