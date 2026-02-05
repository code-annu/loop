import 'package:flutter/material.dart';
import '../../../data/models/models.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_colors.dart';
import 'single_track_view.dart';

/// Section Header Widget
class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;

  const SectionHeader({
    super.key,
    required this.title,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTextStyles.headlineSmall,
          ),
          if (onSeeAll != null)
            TextButton(
              onPressed: onSeeAll,
              child: Text(
                'See All',
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

/// Quick Picks Section with PageView
class QuickPicksSection extends StatelessWidget {
  final List<TrackModel> tracks;
  final Function(TrackModel)? onTrackTap;

  const QuickPicksSection({
    super.key,
    required this.tracks,
    this.onTrackTap,
  });

  @override
  Widget build(BuildContext context) {
    if (tracks.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Quick Picks'),
        SizedBox(
          height: 220,
          child: PageView.builder(
            controller: PageController(viewportFraction: 0.45),
            itemCount: tracks.length,
            itemBuilder: (context, index) {
              return SingleTrackView(
                track: tracks[index],
                onTap: () => onTrackTap?.call(tracks[index]),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Random Picks Section with PageView
class RandomPicksSection extends StatelessWidget {
  final List<TrackModel> tracks;
  final Function(TrackModel)? onTrackTap;

  const RandomPicksSection({
    super.key,
    required this.tracks,
    this.onTrackTap,
  });

  @override
  Widget build(BuildContext context) {
    if (tracks.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Random Picks'),
        SizedBox(
          height: 220,
          child: PageView.builder(
            controller: PageController(viewportFraction: 0.45),
            itemCount: tracks.length,
            itemBuilder: (context, index) {
              return SingleTrackView(
                track: tracks[index],
                onTap: () => onTrackTap?.call(tracks[index]),
              );
            },
          ),
        ),
      ],
    );
  }
}
