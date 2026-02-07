import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../bloc/player_bloc.dart';
import '../bloc/player_state.dart';
import '../bloc/player_event.dart';

/// Full-screen Player Bottom Sheet
class PlayerBottomSheet extends StatelessWidget {
  const PlayerBottomSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: false, // Allow drawing behind status bar
      backgroundColor: Colors.transparent,
      builder: (context) => const PlayerBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerBloc, PlayerState>(
      builder: (context, state) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  state.dominantColor ?? const Color(0xFF1E3A5F),
                  AppColors.background,
                ],
              ),
            ),
            child: SafeArea(
              minimum: const EdgeInsets.only(top: 16),
              child: Column(
                children: [
                  // Top bar
                  _buildTopBar(context, state),
                  const Spacer(),
                  // Cover image
                  _buildCoverImage(state),
                  const Spacer(),
                  // Track info
                  _buildTrackInfo(state),
                  const SizedBox(height: 24),
                  // Seekbar
                  _buildSeekbar(context, state),
                  const SizedBox(height: 24),
                  // Controls
                  _buildControls(context, state),
                  const SizedBox(
                    height: 24,
                  ), // Reduced bottom margin since SafeArea handles bottom
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTopBar(BuildContext context, PlayerState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Collapse button
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.keyboard_arrow_down,
              color: AppColors.onBackground,
              size: 32,
            ),
          ),
          // Playing from info
          Expanded(
            child: Column(
              children: [
                Text(
                  'PLAYING FROM PLAYLIST',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.onSurfaceSecondary,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  state.playingFrom ?? 'Unknown',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.onBackground,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // Playlist button
          IconButton(
            onPressed: () => _showPlaylist(context, state),
            icon: const Icon(
              Icons.queue_music,
              color: AppColors.onBackground,
              size: 28,
            ),
          ),
          // Menu button
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert, color: AppColors.onBackground),
          ),
        ],
      ),
    );
  }

  Widget _buildCoverImage(PlayerState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 30,
                offset: const Offset(0, 15),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: _buildImage(state.currentTrack?.coverUrl),
          ),
        ),
      ),
    );
  }

  Widget _buildImage(String? url) {
    if (url != null && url.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: url,
        fit: BoxFit.cover,
        placeholder: (context, url) => _buildPlaceholder(),
        errorWidget: (context, url, error) => _buildPlaceholder(),
      );
    }
    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.surfaceVariant,
      child: const Center(
        child: Icon(
          Icons.music_note,
          size: 80,
          color: AppColors.onSurfaceSecondary,
        ),
      ),
    );
  }

  Widget _buildTrackInfo(PlayerState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            state.currentTrack?.title ?? 'No track',
            style: AppTextStyles.titleLarge.copyWith(
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            state.currentTrack?.artistNames ?? 'Unknown Artist',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.onSurfaceSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildSeekbar(BuildContext context, PlayerState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
              activeTrackColor: AppColors.onBackground,
              inactiveTrackColor: AppColors.surfaceVariant,
              thumbColor: AppColors.onBackground,
              overlayColor: AppColors.onBackground.withValues(alpha: 0.2),
            ),
            child: Slider(
              value: state.progress.clamp(0.0, 1.0),
              onChanged: (value) {
                final position = Duration(
                  milliseconds: (value * state.duration.inMilliseconds).toInt(),
                );
                context.read<PlayerBloc>().add(SeekTo(position));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(state.formattedPosition, style: AppTextStyles.labelSmall),
                Text(state.formattedDuration, style: AppTextStyles.labelSmall),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControls(BuildContext context, PlayerState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Previous button
        IconButton(
          onPressed:
              () => context.read<PlayerBloc>().add(const PreviousTrack()),
          icon: const Icon(
            Icons.skip_previous,
            color: AppColors.onBackground,
            size: 40,
          ),
        ),
        const SizedBox(width: 24),
        // Play/Pause button
        Container(
          decoration: const BoxDecoration(
            color: AppColors.onBackground,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed:
                () => context.read<PlayerBloc>().add(const TogglePlayPause()),
            iconSize: 40,
            padding: const EdgeInsets.all(16),
            icon: Icon(
              state.isPlaying ? Icons.pause : Icons.play_arrow,
              color: AppColors.background,
            ),
          ),
        ),
        const SizedBox(width: 24),
        // Next button
        IconButton(
          onPressed: () => context.read<PlayerBloc>().add(const NextTrack()),
          icon: const Icon(
            Icons.skip_next,
            color: AppColors.onBackground,
            size: 40,
          ),
        ),
      ],
    );
  }

  void _showPlaylist(BuildContext context, PlayerState state) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.6,
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Playlist',
                        style: AppTextStyles.titleLarge.copyWith(
                          color: AppColors.onBackground,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${state.currentIndex + 1}/${state.playlist.length}',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.onSurfaceSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(color: AppColors.surfaceVariant),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.playlist.length,
                    itemBuilder: (context, index) {
                      final track = state.playlist[index];
                      final isCurrent = index == state.currentIndex;
                      return ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: SizedBox(
                            width: 48,
                            height: 48,
                            child:
                                track.coverUrl != null
                                    ? CachedNetworkImage(
                                      imageUrl: track.coverUrl!,
                                      fit: BoxFit.cover,
                                      placeholder:
                                          (_, __) => Container(
                                            color: AppColors.surfaceVariant,
                                          ),
                                      errorWidget:
                                          (_, __, ___) =>
                                              const Icon(Icons.music_note),
                                    )
                                    : Container(
                                      color: AppColors.surfaceVariant,
                                      child: const Icon(Icons.music_note),
                                    ),
                          ),
                        ),
                        title: Text(
                          track.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.bodyLarge.copyWith(
                            color:
                                isCurrent
                                    ? AppColors.primary
                                    : AppColors.onBackground,
                            fontWeight:
                                isCurrent ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        subtitle: Text(
                          track.artistNames,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color:
                                isCurrent
                                    ? AppColors.primary.withValues(alpha: 0.7)
                                    : AppColors.onSurfaceSecondary,
                          ),
                        ),
                        trailing:
                            isCurrent
                                ? const Icon(
                                  Icons.graphic_eq,
                                  color: AppColors.primary,
                                )
                                : null,
                        onTap: () {
                          context.read<PlayerBloc>().add(PlayTrackAt(index));
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
