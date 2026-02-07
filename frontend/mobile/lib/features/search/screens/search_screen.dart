import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/models.dart';
import '../../../data/repositories/track_repository.dart';
import '../../../data/repositories/album_repository.dart';
import '../../player/bloc/player_bloc.dart';
import '../../player/bloc/player_event.dart';
import '../../album/screens/album_screen.dart';
import '../bloc/search_bloc.dart';
import '../bloc/search_event.dart';
import '../bloc/search_state.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => SearchBloc(
            trackRepository: TrackRepository(),
            albumRepository: AlbumRepository(),
          ),
      child: const _SearchView(),
    );
  }
}

class _SearchView extends StatefulWidget {
  const _SearchView();

  @override
  State<_SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<_SearchView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Search', style: AppTextStyles.headlineMedium),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search songs, albums...',
                hintStyle: TextStyle(color: AppColors.onSurfaceSecondary),
                prefixIcon: Icon(
                  Icons.search,
                  color: AppColors.onSurfaceSecondary,
                ),
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onChanged: (query) {
                context.read<SearchBloc>().add(SearchQueryChanged(query));
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                if (state is SearchLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  );
                }

                if (state is SearchError) {
                  return Center(
                    child: Text(
                      'Error: ${state.message}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }

                if (state is SearchLoaded) {
                  if (state.tracks.isEmpty && state.albums.isEmpty) {
                    return Center(
                      child: Text(
                        'No results found',
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.onSurfaceSecondary,
                        ),
                      ),
                    );
                  }

                  return ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      if (state.albums.isNotEmpty) ...[
                        Text('Albums', style: AppTextStyles.headlineSmall),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 160,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: state.albums.length,
                            separatorBuilder:
                                (_, __) => const SizedBox(width: 16),
                            itemBuilder: (context, index) {
                              final album = state.albums[index];
                              return _AlbumCard(album: album);
                            },
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                      if (state.tracks.isNotEmpty) ...[
                        Text('Songs', style: AppTextStyles.headlineSmall),
                        const SizedBox(height: 12),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.tracks.length,
                          separatorBuilder:
                              (_, __) => const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            final track = state.tracks[index];
                            return _TrackItem(
                              track: track,
                              playlist: state.tracks,
                            );
                          },
                        ),
                      ],
                    ],
                  );
                }

                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.music_note,
                        size: 80,
                        color: AppColors.onSurfaceSecondary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Play what you love',
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.onSurfaceSecondary,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _AlbumCard extends StatelessWidget {
  final AlbumModel album;

  const _AlbumCard({required this.album});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AlbumScreen(albumId: album.id),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: album.coverUrl ?? '',
                width: 120,
                height: 120,
                fit: BoxFit.cover,
                placeholder:
                    (context, url) => Container(
                      color: AppColors.surface,
                      child: const Icon(
                        Icons.album,
                        color: AppColors.onSurfaceSecondary,
                      ),
                    ),
                errorWidget:
                    (context, url, error) => Container(
                      color: AppColors.surface,
                      child: const Icon(Icons.error),
                    ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: 120,
              child: Text(
                album.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrackItem extends StatelessWidget {
  final TrackModel track;
  final List<TrackModel> playlist;

  const _TrackItem({required this.track, required this.playlist});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: () {
          context.read<PlayerBloc>().add(
            LoadPlaylist(
              tracks: playlist,
              initialIndex: playlist.indexOf(track),
              playingFrom: 'Search Results',
            ),
          );
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          decoration: BoxDecoration(
            // color: AppColors.surface, // Moved to Material
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: CachedNetworkImage(
                  imageUrl: track.coverUrl ?? '',
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                  placeholder:
                      (context, url) => Container(color: AppColors.background),
                  errorWidget:
                      (context, url, error) => Container(
                        color: AppColors.background,
                        child: const Icon(Icons.music_note),
                      ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      track.title,
                      style: AppTextStyles.bodyMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      track.artistNames,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.onSurfaceSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (track.duration > 0)
                Text(
                  track.formattedDuration,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.onSurfaceSecondary,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
