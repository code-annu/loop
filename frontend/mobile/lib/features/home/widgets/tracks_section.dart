import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../data/models/models.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class TracksSection extends StatelessWidget {
  final List<TrackModel> tracks;
  final Function(TrackModel) onTrackTap;
  final String title;

  const TracksSection({
    super.key,
    required this.tracks,
    required this.onTrackTap,
    this.title = 'Top Tracks',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(title, style: AppTextStyles.titleLarge),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 180, // Height for square boxes
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: tracks.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final track = tracks[index];
              return GestureDetector(
                onTap: () => onTrackTap(track),
                child: Container(
                  width: 140, // Width for square boxes
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(8),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: track.coverUrl ?? '',
                          height: 130, // Square image area
                          width: double.infinity,
                          fit: BoxFit.cover,
                          placeholder:
                              (context, url) => Container(
                                color: AppColors.surfaceContainerHighest,
                              ),
                          errorWidget:
                              (context, url, error) => Container(
                                color: AppColors.surfaceContainerHighest,
                                child: const Icon(
                                  Icons.music_note,
                                  color: AppColors.onSurfaceVariant,
                                ),
                              ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            track.title,
                            style: AppTextStyles.bodySmall.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
