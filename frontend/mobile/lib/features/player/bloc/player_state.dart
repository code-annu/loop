import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/models.dart';

/// Player Bloc States
class PlayerState extends Equatable {
  final List<TrackModel> playlist;
  final TrackModel? currentTrack;
  final int currentIndex;
  final String? playingFrom;
  final Duration position;
  final Duration duration;
  final bool isPlaying;
  final bool isLoading;
  final bool hasTrack;
  final Color? dominantColor;

  const PlayerState({
    this.playlist = const [],
    this.currentTrack,
    this.currentIndex = 0,
    this.playingFrom,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.isPlaying = false,
    this.isLoading = false,
    this.hasTrack = false,
    this.dominantColor,
  });

  PlayerState copyWith({
    List<TrackModel>? playlist,
    TrackModel? currentTrack,
    int? currentIndex,
    String? playingFrom,
    Duration? position,
    Duration? duration,
    bool? isPlaying,
    bool? isLoading,
    bool? hasTrack,
    Color? dominantColor,
  }) {
    return PlayerState(
      playlist: playlist ?? this.playlist,
      currentTrack: currentTrack ?? this.currentTrack,
      currentIndex: currentIndex ?? this.currentIndex,
      playingFrom: playingFrom ?? this.playingFrom,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      isPlaying: isPlaying ?? this.isPlaying,
      isLoading: isLoading ?? this.isLoading,
      hasTrack: hasTrack ?? this.hasTrack,
      dominantColor: dominantColor ?? this.dominantColor,
    );
  }

  @override
  List<Object?> get props => [
    playlist,
    currentTrack,
    currentIndex,
    playingFrom,
    position,
    duration,
    isPlaying,
    isLoading,
    hasTrack,
    dominantColor,
  ];

  /// Get formatted position string (MM:SS)
  String get formattedPosition {
    final minutes = position.inMinutes;
    final seconds = position.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Get formatted duration string (MM:SS)
  String get formattedDuration {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Get progress as percentage (0.0 to 1.0)
  double get progress {
    if (duration.inMilliseconds == 0) return 0;
    return position.inMilliseconds / duration.inMilliseconds;
  }
}
