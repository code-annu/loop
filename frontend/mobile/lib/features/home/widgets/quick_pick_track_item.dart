import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../data/models/models.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

/// Quick Pick Track Item Widget
/// Displays track in a list-tile style with artwork, title, artist info, and menu button
class QuickPickTrackItem extends StatelessWidget {
  final TrackModel track;
  final VoidCallback? onTap;
  final VoidCallback? onMenuTap;

  const QuickPickTrackItem({
    super.key,
    required this.track,
    this.onTap,
    this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            // Track Artwork
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: _buildArtwork(),
            ),
            const SizedBox(width: 12),
            // Track Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    track.title,
                    style: AppTextStyles.titleSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _buildSubtitle(),
                    style: AppTextStyles.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Menu Button
            IconButton(
              onPressed: onMenuTap,
              icon: const Icon(
                Icons.more_vert,
                color: AppColors.onSurfaceSecondary,
                size: 24,
              ),
              splashRadius: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArtwork() {
    const double size = 56;
    if (track.coverUrl != null && track.coverUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: track.coverUrl!,
        fit: BoxFit.cover,
        width: size,
        height: size,
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

  String _buildSubtitle() {
    final artistName = track.artistNames.isNotEmpty 
        ? track.artistNames 
        : 'Unknown Artist';
    // For now we don't have play count in TrackModel, just show artist
    return artistName;
  }
}
