import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../bloc/player_bloc.dart';
import '../bloc/player_state.dart';
import '../bloc/player_event.dart';
import '../screens/player_bottom_sheet.dart';

/// Mini Player Widget - Displayed above bottom navigation bar
class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerBloc, PlayerState>(
      builder: (context, state) {
        // Don't show if no track is loaded
        if (!state.hasTrack || state.currentTrack == null) {
          return const SizedBox.shrink();
        }

        return GestureDetector(
          onTap: () => PlayerBottomSheet.show(context),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: state.dominantColor ?? AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Progress bar at top
                  LinearProgressIndicator(
                    value: state.progress.clamp(0.0, 1.0),
                    backgroundColor: AppColors.surfaceVariant.withValues(
                      alpha: 0.3,
                    ),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
                    ),
                    minHeight: 2,
                  ),
                  // Main content
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        // Cover image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: _buildCover(state.currentTrack!.coverUrl),
                        ),
                        const SizedBox(width: 12),
                        // Track info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                state.currentTrack!.title,
                                style: AppTextStyles.titleSmall,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                state.currentTrack!.artistNames.isNotEmpty
                                    ? state.currentTrack!.artistNames
                                    : 'Unknown Artist',
                                style: AppTextStyles.bodySmall,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        // Play/Pause button
                        IconButton(
                          onPressed:
                              () => context.read<PlayerBloc>().add(
                                const TogglePlayPause(),
                              ),
                          icon: Icon(
                            state.isPlaying ? Icons.pause : Icons.play_arrow,
                            color: AppColors.onBackground,
                            size: 28,
                          ),
                        ),
                        // Next button
                        IconButton(
                          onPressed:
                              () => context.read<PlayerBloc>().add(
                                const NextTrack(),
                              ),
                          icon: const Icon(
                            Icons.skip_next,
                            color: AppColors.onBackground,
                            size: 28,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCover(String? url) {
    const double size = 48;
    if (url != null && url.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: url,
        width: size,
        height: size,
        fit: BoxFit.cover,
        placeholder: (context, url) => _buildPlaceholder(size),
        errorWidget: (context, url, error) => _buildPlaceholder(size),
      );
    }
    return _buildPlaceholder(size);
  }

  Widget _buildPlaceholder(double size) {
    return Container(
      width: size,
      height: size,
      color: AppColors.surfaceVariant,
      child: const Center(
        child: Icon(
          Icons.music_note,
          size: 24,
          color: AppColors.onSurfaceSecondary,
        ),
      ),
    );
  }
}
