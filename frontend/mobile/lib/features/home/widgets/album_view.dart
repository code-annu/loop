import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../data/models/models.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

/// Album View Widget
/// Displays album cover, title, and artist info
class AlbumView extends StatelessWidget {
  final AlbumModel album;
  final VoidCallback? onTap;
  final double width;
  final double height;

  const AlbumView({
    super.key,
    required this.album,
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
            // Album Cover
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
                  child: _buildCover(),
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Album Title
            Text(
              album.title,
              style: AppTextStyles.titleSmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            // Artist Names
            Text(
              album.artistNames.isNotEmpty ? album.artistNames : 'Various Artists',
              style: AppTextStyles.bodySmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCover() {
    if (album.coverUrl != null && album.coverUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: album.coverUrl!,
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
          Icons.album,
          size: 48,
          color: AppColors.onSurfaceSecondary,
        ),
      ),
    );
  }
}
