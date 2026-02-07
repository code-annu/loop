import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart' as ja;
import 'package:palette_generator/palette_generator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/services/audio_player_service.dart';
import '../../../data/repositories/track_repository.dart';
import '../../../data/models/models.dart';
import 'player_event.dart';
import 'player_state.dart';

/// Player BLoC - Manages player state and audio playback
class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {
  final AudioPlayerService _audioService = AudioPlayerService();
  final TrackRepository _trackRepository;

  StreamSubscription<ja.PlayerState>? _playerStateSubscription;
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<Duration?>? _durationSubscription;
  StreamSubscription<int?>? _currentIndexSubscription;

  PlayerBloc({TrackRepository? trackRepository})
    : _trackRepository = trackRepository ?? TrackRepository(),
      super(const PlayerState()) {
    on<LoadPlaylist>(_onLoadPlaylist);
    on<TogglePlayPause>(_onTogglePlayPause);
    on<NextTrack>(_onNextTrack);
    on<PreviousTrack>(_onPreviousTrack);
    on<SeekTo>(_onSeekTo);
    on<PlayTrackAt>(_onPlayTrackAt);
    on<_UpdatePlayerState>(_onUpdatePlayerState);
    on<_UpdatePosition>(_onUpdatePosition);
    on<_UpdateDuration>(_onUpdateDuration);
    on<_UpdateCurrentIndex>(_onUpdateCurrentIndex);
    on<_UpdatePalette>(_onUpdatePalette);
    on<_FetchMoreTracks>(_onFetchMoreTracks);

    _initStreams();
  }

  // ... _initStreams ...

  // ... other methods ...

  void _onUpdateCurrentIndex(
    _UpdateCurrentIndex event,
    Emitter<PlayerState> emit,
  ) {
    if (event.index < state.playlist.length) {
      final track = state.playlist[event.index];
      emit(state.copyWith(currentIndex: event.index, currentTrack: track));
      _generatePalette(track.coverUrl);

      // Check if we reached the last track
      if (event.index >= state.playlist.length - 1) {
        add(const _FetchMoreTracks());
      }
    }
  }

  Future<void> _onFetchMoreTracks(
    _FetchMoreTracks event,
    Emitter<PlayerState> emit,
  ) async {
    try {
      debugPrint('PlayerBloc: Fetching more random tracks...');
      final newTracks = await _trackRepository.getRandomTracks(limit: 5);
      if (newTracks.isNotEmpty) {
        await _audioService.addTracks(newTracks);

        // Update local playlist state
        final updatedPlaylist = List<TrackModel>.from(state.playlist)
          ..addAll(newTracks);
        emit(state.copyWith(playlist: updatedPlaylist));

        debugPrint('PlayerBloc: Added ${newTracks.length} tracks to playlist');
      }
    } catch (e) {
      debugPrint('PlayerBloc: Error fetching more tracks: $e');
    }
  }

  void _initStreams() {
    // Listen to player state changes
    _playerStateSubscription = _audioService.playerStateStream.listen((
      playerState,
    ) {
      add(
        _UpdatePlayerState(
          isPlaying: playerState.playing,
          isLoading:
              playerState.processingState == ja.ProcessingState.loading ||
              playerState.processingState == ja.ProcessingState.buffering,
        ),
      );
    });

    // Listen to position changes
    _positionSubscription = _audioService.positionStream.listen((position) {
      add(_UpdatePosition(position));
    });

    // Listen to duration changes
    _durationSubscription = _audioService.durationStream.listen((duration) {
      if (duration != null) {
        add(_UpdateDuration(duration));
      }
    });

    // Listen to current index changes
    _currentIndexSubscription = _audioService.currentIndexStream.listen((
      index,
    ) {
      if (index != null) {
        add(_UpdateCurrentIndex(index));
      }
    });
  }

  void _onUpdatePlayerState(
    _UpdatePlayerState event,
    Emitter<PlayerState> emit,
  ) {
    emit(
      state.copyWith(isPlaying: event.isPlaying, isLoading: event.isLoading),
    );
  }

  void _onUpdatePosition(_UpdatePosition event, Emitter<PlayerState> emit) {
    emit(state.copyWith(position: event.position));
  }

  void _onUpdateDuration(_UpdateDuration event, Emitter<PlayerState> emit) {
    emit(state.copyWith(duration: event.duration));
  }

  void _onUpdatePalette(_UpdatePalette event, Emitter<PlayerState> emit) {
    emit(state.copyWith(dominantColor: event.color));
  }

  Future<void> _generatePalette(String? url) async {
    if (url == null) {
      add(const _UpdatePalette(null));
      return;
    }

    try {
      final PaletteGenerator generator =
          await PaletteGenerator.fromImageProvider(
            CachedNetworkImageProvider(url),
          );

      final color =
          generator.darkMutedColor?.color ?? generator.darkVibrantColor?.color;
      add(_UpdatePalette(color));
    } catch (e) {
      debugPrint('PlayerBloc: Error generating palette: $e');
      add(const _UpdatePalette(null));
    }
  }

  Future<void> _onLoadPlaylist(
    LoadPlaylist event,
    Emitter<PlayerState> emit,
  ) async {
    debugPrint(
      'PlayerBloc: Loading playlist with ${event.tracks.length} tracks',
    );
    debugPrint('PlayerBloc: Initial index: ${event.initialIndex}');
    debugPrint(
      'PlayerBloc: Track URL: ${event.tracks[event.initialIndex].trackUrl}',
    );

    final initialTrack = event.tracks[event.initialIndex];

    emit(
      state.copyWith(
        isLoading: true,
        playlist: event.tracks,
        playingFrom: event.playingFrom,
        currentIndex: event.initialIndex,
        currentTrack: initialTrack,
        hasTrack: true,
        dominantColor: null, // Reset color initially
      ),
    );

    // Start generating palette for the initial track
    _generatePalette(initialTrack.coverUrl);

    try {
      await _audioService.loadPlaylist(
        tracks: event.tracks,
        playingFrom: event.playingFrom,
        initialIndex: event.initialIndex,
      );
      debugPrint('PlayerBloc: Playlist loaded, starting playback');

      await _audioService.play();
      debugPrint('PlayerBloc: Play called');
    } catch (e) {
      debugPrint('PlayerBloc: Error during playback: $e');
    }
  }

  Future<void> _onTogglePlayPause(
    TogglePlayPause event,
    Emitter<PlayerState> emit,
  ) async {
    await _audioService.togglePlayPause();
  }

  Future<void> _onNextTrack(NextTrack event, Emitter<PlayerState> emit) async {
    await _audioService.next();
  }

  Future<void> _onPreviousTrack(
    PreviousTrack event,
    Emitter<PlayerState> emit,
  ) async {
    await _audioService.previous();
  }

  Future<void> _onSeekTo(SeekTo event, Emitter<PlayerState> emit) async {
    await _audioService.seek(event.position);
  }

  Future<void> _onPlayTrackAt(
    PlayTrackAt event,
    Emitter<PlayerState> emit,
  ) async {
    await _audioService.playAt(event.index);
  }

  @override
  Future<void> close() {
    _playerStateSubscription?.cancel();
    _positionSubscription?.cancel();
    _durationSubscription?.cancel();
    _currentIndexSubscription?.cancel();
    return super.close();
  }
}

// Internal events for stream updates
class _UpdatePlayerState extends PlayerEvent {
  final bool isPlaying;
  final bool isLoading;
  const _UpdatePlayerState({required this.isPlaying, required this.isLoading});

  @override
  List<Object?> get props => [isPlaying, isLoading];
}

class _UpdatePosition extends PlayerEvent {
  final Duration position;
  const _UpdatePosition(this.position);

  @override
  List<Object?> get props => [position];
}

class _UpdateDuration extends PlayerEvent {
  final Duration duration;
  const _UpdateDuration(this.duration);

  @override
  List<Object?> get props => [duration];
}

class _UpdateCurrentIndex extends PlayerEvent {
  final int index;
  const _UpdateCurrentIndex(this.index);

  @override
  List<Object?> get props => [index];
}

class _UpdatePalette extends PlayerEvent {
  final Color? color;
  const _UpdatePalette(this.color);

  @override
  List<Object?> get props => [color];
}

class _FetchMoreTracks extends PlayerEvent {
  const _FetchMoreTracks();

  @override
  List<Object?> get props => [];
}
