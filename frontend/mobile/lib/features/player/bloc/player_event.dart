import 'package:equatable/equatable.dart';
import '../../../data/models/models.dart';

/// Player Bloc Events
abstract class PlayerEvent extends Equatable {
  const PlayerEvent();

  @override
  List<Object?> get props => [];
}

/// Load a playlist and start playing
class LoadPlaylist extends PlayerEvent {
  final List<TrackModel> tracks;
  final String playingFrom;
  final int initialIndex;

  const LoadPlaylist({
    required this.tracks,
    required this.playingFrom,
    this.initialIndex = 0,
  });

  @override
  List<Object?> get props => [tracks, playingFrom, initialIndex];
}

/// Toggle play/pause
class TogglePlayPause extends PlayerEvent {
  const TogglePlayPause();
}

/// Skip to next track
class NextTrack extends PlayerEvent {
  const NextTrack();
}

/// Skip to previous track
class PreviousTrack extends PlayerEvent {
  const PreviousTrack();
}

/// Seek to position
class SeekTo extends PlayerEvent {
  final Duration position;

  const SeekTo(this.position);

  @override
  List<Object?> get props => [position];
}

/// Play track at specific index
class PlayTrackAt extends PlayerEvent {
  final int index;

  const PlayTrackAt(this.index);

  @override
  List<Object?> get props => [index];
}
