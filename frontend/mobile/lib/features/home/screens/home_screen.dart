import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../widgets/home_sections.dart';
import '../widgets/new_albums_section.dart';
import '../widgets/tracks_section.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../player/bloc/player_bloc.dart';
import '../../player/bloc/player_event.dart';
import '../../../data/models/models.dart';
import '../../album/screens/album_screen.dart';

/// Home Screen
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc()..add(const FetchHomeData()),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Good Evening', style: AppTextStyles.headlineMedium),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<HomeBloc>().add(const FetchHomeData());
        },
        color: AppColors.primary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              // Check for initial loading state (loading AND no data)
              final isInitialLoading =
                  (state.quickPicksStatus == HomeSectionStatus.loading ||
                      state.newAlbumsStatus == HomeSectionStatus.loading ||
                      state.randomPicksStatus == HomeSectionStatus.loading ||
                      state.tracksStatus == HomeSectionStatus.loading) &&
                  (state.quickPicks.isEmpty &&
                      state.newAlbums.isEmpty &&
                      state.randomPicks.isEmpty &&
                      state.tracks.isEmpty);

              if (isInitialLoading) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),

                  // Quick Picks Section (Async)
                  _buildSection(
                    status: state.quickPicksStatus,
                    child: QuickPicksSection(
                      tracks: state.quickPicks,
                      onTrackTap:
                          (track) => _playTrack(
                            context,
                            tracks: state.quickPicks,
                            track: track,
                            playingFrom: 'Quick picks',
                          ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // New Released Albums Section (Async)
                  _buildSection(
                    status: state.newAlbumsStatus,
                    child: NewAlbumsSection(
                      albums: state.newAlbums,
                      onAlbumTap: (album) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => AlbumScreen(albumId: album.id),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Random Picks Section (Async)
                  _buildSection(
                    status: state.randomPicksStatus,
                    child: RandomPicksSection(
                      tracks: state.randomPicks,
                      onTrackTap:
                          (track) => _playTrack(
                            context,
                            tracks: state.randomPicks,
                            track: track,
                            playingFrom: 'Random picks',
                          ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Tracks Section (Async)
                  _buildSection(
                    status: state.tracksStatus,
                    child: TracksSection(
                      title: 'Just for You',
                      tracks: state.tracks,
                      onTrackTap:
                          (track) => _playTrack(
                            context,
                            tracks: state.tracks,
                            track: track,
                            playingFrom: 'Just for You',
                          ),
                    ),
                  ),

                  const SizedBox(
                    height: 100,
                  ), // Bottom padding for navigation bar
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required HomeSectionStatus status,
    required Widget child,
  }) {
    // If loading, we still show the child (or empty if no data yet, but managed by top level for initial load).
    // During refresh, this will show the existing child.
    if (status == HomeSectionStatus.error) {
      return const SizedBox.shrink(); // Hide section on error
    }

    if (status == HomeSectionStatus.initial) {
      return const SizedBox.shrink();
    }

    return child;
  }

  void _playTrack(
    BuildContext context, {
    required List<TrackModel> tracks,
    required TrackModel track,
    required String playingFrom,
  }) {
    // Find index of clicked track
    final index = tracks.indexWhere((t) => t.id == track.id);

    // Load playlist and start playing
    context.read<PlayerBloc>().add(
      LoadPlaylist(
        tracks: tracks,
        playingFrom: playingFrom,
        initialIndex: index >= 0 ? index : 0,
      ),
    );
  }
}
