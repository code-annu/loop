import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../data/models/models.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

/// Single Track View Widget
/// Displays track artwork, title, and artist name
class SingleTrackView extends StatelessWidget {
  final TrackModel track;
  final VoidCallback? onTap;
  final double width;
  final double height;

  const SingleTrackView({
    super.key,
    required this.track,
    this.onTap,
    this.width = 160,
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Track Artwork
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: _buildArtwork(),
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Track Title
            Text(
              track.title,
              style: AppTextStyles.titleSmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            // Artist Name
            Text(
              track.artistNames.isNotEmpty ? track.artistNames : 'Unknown Artist',
              style: AppTextStyles.bodySmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArtwork() {
    if (track.coverUrl != null && track.coverUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: track.coverUrl!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
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
          size: 48,
          color: AppColors.onSurfaceSecondary,
        ),
      ),
    );
  }
}
