import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../widgets/home_sections.dart';
import '../widgets/new_albums_section.dart';
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
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (state is HomeError) {
            return _buildErrorView(context, state.message);
          }

          if (state is HomeLoaded) {
            return _buildLoadedView(context, state);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildErrorView(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: AppColors.error),
            const SizedBox(height: 16),
            Text('Something went wrong', style: AppTextStyles.titleLarge),
            const SizedBox(height: 8),
            Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.onSurfaceSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.read<HomeBloc>().add(const FetchHomeData());
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadedView(BuildContext context, HomeLoaded state) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<HomeBloc>().add(const FetchHomeData());
      },
      color: AppColors.primary,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            // Quick Picks Section
            QuickPicksSection(
              tracks: state.quickPicks,
              onTrackTap:
                  (track) => _playTrack(
                    context,
                    tracks: state.quickPicks,
                    track: track,
                    playingFrom: 'Quick picks',
                  ),
            ),
            const SizedBox(height: 24),
            // Random Picks Section
            RandomPicksSection(
              tracks: state.randomPicks,
              onTrackTap:
                  (track) => _playTrack(
                    context,
                    tracks: state.randomPicks,
                    track: track,
                    playingFrom: 'Random picks',
                  ),
            ),
            const SizedBox(height: 24),
            // New Albums Section
            NewAlbumsSection(
              albums: state.newAlbums,
              onAlbumTap: (album) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AlbumScreen(albumId: album.id),
                  ),
                );
              },
            ),
            const SizedBox(height: 100), // Bottom padding for navigation bar
          ],
        ),
      ),
    );
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
