import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../player/bloc/player_bloc.dart';
import '../../player/bloc/player_event.dart';
import '../../../data/models/models.dart';
import '../bloc/album_bloc.dart';
import '../bloc/album_event.dart';
import '../bloc/album_state.dart';

class AlbumScreen extends StatelessWidget {
  final String albumId;

  const AlbumScreen({super.key, required this.albumId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AlbumBloc()..add(LoadAlbum(albumId)),
      child: const _AlbumView(),
    );
  }
}

class _AlbumView extends StatelessWidget {
  const _AlbumView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<AlbumBloc, AlbumState>(
        builder: (context, state) {
          if (state is AlbumLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AlbumError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 48,
                    color: AppColors.error,
                  ),
                  const SizedBox(height: 16),
                  Text(state.message, style: AppTextStyles.bodyMedium),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Go Back'),
                  ),
                ],
              ),
            );
          }

          if (state is AlbumLoaded) {
            final album = state.album;
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 300,
                  pinned: true,
                  backgroundColor: AppColors.background,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      album.title,
                      style: AppTextStyles.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    background:
                        album.coverUrl != null
                            ? CachedNetworkImage(
                              imageUrl: album.coverUrl!,
                              fit: BoxFit.cover,
                              errorWidget:
                                  (context, url, error) => Container(
                                    color: AppColors.surfaceVariant,
                                    child: const Icon(
                                      Icons.music_note,
                                      size: 64,
                                    ),
                                  ),
                            )
                            : Container(
                              color: AppColors.surfaceVariant,
                              child: const Icon(Icons.music_note, size: 64),
                            ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(album.title, style: AppTextStyles.headlineSmall),
                        const SizedBox(height: 8),
                        Text(
                          album.artistNames,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.onSurfaceSecondary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                if (album.tracks.isNotEmpty) {
                                  _playTrack(
                                    context,
                                    album,
                                    album.tracks.first,
                                  );
                                }
                              },
                              icon: const Icon(Icons.play_arrow),
                              label: const Text('Play'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: AppColors.onPrimary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final track = album.tracks[index];
                    return ListTile(
                      leading: Text(
                        '${index + 1}',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.onSurfaceSecondary,
                        ),
                      ),
                      title: Text(
                        track.title,
                        style: AppTextStyles.bodyLarge,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        album
                            .artistNames, // Use album artists for now or track artists if detailed
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.onSurfaceSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Text(
                        _formatDuration(track.duration),
                        style: AppTextStyles.bodySmall,
                      ),
                      onTap: () => _playTrack(context, album, track),
                    );
                  }, childCount: album.tracks.length),
                ),
                const SliverPadding(
                  padding: EdgeInsets.only(
                    bottom: 100,
                  ), // Spacing for MiniPlayer
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _playTrack(
    BuildContext context,
    AlbumModel album,
    TrackInfoModel trackInfo,
  ) {
    // Convert TrackInfoModel to TrackModel
    // We map full album's tracks to TrackModels
    final tracks =
        album.tracks.map((t) {
          return TrackModel(
            id: t.id,
            title: t.title,
            coverUrl: t.coverUrl ?? album.coverUrl,
            trackUrl: t.trackUrl,
            duration: t.duration,
            album: AlbumInfoModel(id: album.id, title: album.title),
            artists: album.artists, // Assuming album artists apply to tracks
          );
        }).toList();

    final index = tracks.indexWhere((t) => t.id == trackInfo.id);

    context.read<PlayerBloc>().add(
      LoadPlaylist(
        tracks: tracks,
        playingFrom: album.title,
        initialIndex: index >= 0 ? index : 0,
      ),
    );

    // Explicitly do NOT navigate to details, just play
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
