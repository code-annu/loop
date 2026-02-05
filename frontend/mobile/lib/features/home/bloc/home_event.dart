import 'package:equatable/equatable.dart';

/// Home Bloc Events
abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

/// Fetch all home data (quick picks, random picks, new albums)
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
