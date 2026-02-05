import 'package:flutter/material.dart';
import '../../../data/models/models.dart';
import 'album_view.dart';
import 'home_sections.dart';

/// New Albums Section with horizontal ListView
class NewAlbumsSection extends StatelessWidget {
  final List<AlbumModel> albums;
  final Function(AlbumModel)? onAlbumTap;

  const NewAlbumsSection({
    super.key,
    required this.albums,
    this.onAlbumTap,
  });

  @override
  Widget build(BuildContext context) {
    if (albums.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'New Released Albums'),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: albums.length,
            itemBuilder: (context, index) {
              return AlbumView(
                album: albums[index],
                onTap: () => onAlbumTap?.call(albums[index]),
              );
            },
          ),
        ),
      ],
    );
  }
}
