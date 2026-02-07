import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:rxdart/rxdart.dart';
import '../../data/models/models.dart';

/// Audio Player Service - Singleton managing audio playback
class AudioPlayerService {
  static final AudioPlayerService _instance = AudioPlayerService._internal();
  factory AudioPlayerService() => _instance;
  AudioPlayerService._internal();

  final AudioPlayer _player = AudioPlayer();

  // Current playlist and track info
  List<TrackModel> _playlist = [];
  String? _playingFrom;
  ConcatenatingAudioSource? _currentPlaylistSource;

  // Getters
  AudioPlayer get player => _player;
  List<TrackModel> get playlist => _playlist;
  String? get playingFrom => _playingFrom;

  // Stream getters
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;
  Stream<Duration> get positionStream => _player.positionStream;
  Stream<Duration?> get durationStream => _player.durationStream;
  Stream<int?> get currentIndexStream => _player.currentIndexStream;
  Stream<SequenceState?> get sequenceStateStream => _player.sequenceStateStream;

  // Current track
  TrackModel? get currentTrack {
    final index = _player.currentIndex;
    if (index != null && index < _playlist.length) {
      return _playlist[index];
    }
    return null;
  }

  /// Combined stream for position and duration
  Stream<PositionData> get positionDataStream =>
      Rx.combineLatest3<Duration, Duration?, PlayerState, PositionData>(
        _player.positionStream,
        _player.durationStream,
        _player.playerStateStream,
        (position, duration, playerState) => PositionData(
          position: position,
          duration: duration ?? Duration.zero,
          playerState: playerState,
        ),
      );

  /// Initialize the audio service
  static Future<void> init() async {
    await JustAudioBackground.init(
      androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
      androidNotificationChannelName: 'Audio playback',
      androidNotificationOngoing: true,
    );
    debugPrint('AudioPlayerService initialized');
  }

  /// Load a playlist and optionally start playing from a specific index
  Future<void> loadPlaylist({
    required List<TrackModel> tracks,
    required String playingFrom,
    int initialIndex = 0,
  }) async {
    _playlist = tracks;
    _playingFrom = playingFrom;

    // Create audio sources with MediaItem for metadata
    final audioSources = _createAudioSources(tracks);

    // Set the audio source
    try {
      _currentPlaylistSource = ConcatenatingAudioSource(children: audioSources);
      await _player.setAudioSource(
        _currentPlaylistSource!,
        initialIndex: initialIndex,
      );
      debugPrint('AudioPlayerService: Audio source set successfully');
    } catch (e) {
      debugPrint('AudioPlayerService: Error setting audio source: $e');
      rethrow;
    }
  }

  /// Add tracks to the end of the playlist
  Future<void> addTracks(List<TrackModel> tracks) async {
    if (_currentPlaylistSource == null) return;

    _playlist.addAll(tracks);
    final audioSources = _createAudioSources(tracks);
    await _currentPlaylistSource!.addAll(audioSources);
  }

  List<AudioSource> _createAudioSources(List<TrackModel> tracks) {
    return tracks.map((track) {
      return AudioSource.uri(
        Uri.parse(track.trackUrl ?? ''),
        tag: MediaItem(
          id: track.id.toString(),
          album: track.album?.title ?? 'Unknown Album',
          title: track.title,
          artist: track.artistNames,
          artUri: track.coverUrl != null ? Uri.parse(track.coverUrl!) : null,
        ),
      );
    }).toList();
  }

  /// Play
  Future<void> play() async {
    await _player.play();
  }

  /// Pause
  Future<void> pause() async {
    await _player.pause();
  }

  /// Toggle play/pause
  Future<void> togglePlayPause() async {
    if (_player.playing) {
      await pause();
    } else {
      await play();
    }
  }

  /// Seek to position
  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  /// Play next track
  Future<void> next() async {
    await _player.seekToNext();
  }

  /// Play previous track
  Future<void> previous() async {
    await _player.seekToPrevious();
  }

  /// Play track at specific index
  Future<void> playAt(int index) async {
    await _player.seek(Duration.zero, index: index);
    await _player.play();
  }

  /// Stop and clean up
  Future<void> stop() async {
    await _player.stop();
  }

  /// Dispose the player
  Future<void> dispose() async {
    await _player.dispose();
  }
}

/// Data class for combining position, duration and player state
class PositionData {
  final Duration position;
  final Duration duration;
  final PlayerState playerState;

  PositionData({
    required this.position,
    required this.duration,
    required this.playerState,
  });

  double get progress {
    if (duration.inMilliseconds == 0) return 0;
    return position.inMilliseconds / duration.inMilliseconds;
  }
}
