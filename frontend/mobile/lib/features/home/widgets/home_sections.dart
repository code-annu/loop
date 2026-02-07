import 'package:flutter/material.dart';
import '../../../data/models/models.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_colors.dart';
import 'quick_pick_track_item.dart';

/// Section Header Widget
class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;
  final String? actionLabel;

  const SectionHeader({
    super.key,
    required this.title,
    this.onSeeAll,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTextStyles.headlineSmall),
          if (onSeeAll != null)
            TextButton(
              onPressed: onSeeAll,
              child: Text(
                actionLabel ?? 'See All',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Quick Picks Section with horizontal scrolling grid (4 rows)
class QuickPicksSection extends StatelessWidget {
  final List<TrackModel> tracks;
  final Function(TrackModel)? onTrackTap;
  final VoidCallback? onPlayAll;
  final Function(TrackModel)? onMenuTap;

  const QuickPicksSection({
    super.key,
    required this.tracks,
    this.onTrackTap,
    this.onPlayAll,
    this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    if (tracks.isEmpty) {
      return const SizedBox.shrink();
    }

    // Calculate item height for 4 rows
    const double itemHeight = 72;
    const double gridHeight = itemHeight * 4;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Quick picks',
          onSeeAll: onPlayAll,
          actionLabel: 'Play all',
        ),
        SizedBox(
          height: gridHeight,
          child: GridView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 0,
              crossAxisSpacing: 0,
              childAspectRatio: 0.22, // height / width ratio for list items
            ),
            itemCount: tracks.length,
            itemBuilder: (context, index) {
              return QuickPickTrackItem(
                track: tracks[index],
                onTap: () => onTrackTap?.call(tracks[index]),
                onMenuTap: () => onMenuTap?.call(tracks[index]),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Random Picks Section with horizontal scrolling grid (4 rows)
class RandomPicksSection extends StatelessWidget {
  final List<TrackModel> tracks;
  final Function(TrackModel)? onTrackTap;
  final VoidCallback? onPlayAll;
  final Function(TrackModel)? onMenuTap;

  const RandomPicksSection({
    super.key,
    required this.tracks,
    this.onTrackTap,
    this.onPlayAll,
    this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    if (tracks.isEmpty) {
      return const SizedBox.shrink();
    }

    // Calculate item height for 4 rows
    const double itemHeight = 72;
    const double gridHeight = itemHeight * 4;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Random picks',
          onSeeAll: onPlayAll,
          actionLabel: 'Play all',
        ),
        SizedBox(
          height: gridHeight,
          child: GridView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 0,
              crossAxisSpacing: 0,
              childAspectRatio: 0.22, // height / width ratio for list items
            ),
            itemCount: tracks.length,
            itemBuilder: (context, index) {
              return QuickPickTrackItem(
                track: tracks[index],
                onTap: () => onTrackTap?.call(tracks[index]),
                onMenuTap: () => onMenuTap?.call(tracks[index]),
              );
            },
          ),
        ),
      ],
    );
  }
}
