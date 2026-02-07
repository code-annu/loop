import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import '../../../data/models/models.dart';
import '../../../data/repositories/track_repository.dart';
import '../../../data/repositories/album_repository.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final TrackRepository _trackRepository;
  final AlbumRepository _albumRepository;

  SearchBloc({
    TrackRepository? trackRepository,
    AlbumRepository? albumRepository,
  }) : _trackRepository = trackRepository ?? TrackRepository(),
       _albumRepository = albumRepository ?? AlbumRepository(),
       super(SearchInitial()) {
    on<SearchQueryChanged>(
      _onSearchQueryChanged,
      transformer: (events, mapper) {
        return events
            .debounceTime(const Duration(milliseconds: 500))
            .switchMap(mapper);
      },
    );
  }

  Future<void> _onSearchQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    if (event.query.isEmpty) {
      emit(SearchInitial());
      return;
    }

    emit(SearchLoading());

    try {
      // Execute searches in parallel
      final tracksFuture = _trackRepository.searchTracks(event.query);
      final albumsFuture = _albumRepository.searchAlbums(event.query);

      final results = await Future.wait([tracksFuture, albumsFuture]);

      emit(
        SearchLoaded(
          tracks: results[0] as List<TrackModel>,
          albums: results[1] as List<AlbumModel>,
        ),
      );

      // Better typing
      // final tracks = await _trackRepository.searchTracks(event.query);
      // final albums = await _albumRepository.searchAlbums(event.query);
      // emit(SearchLoaded(tracks: tracks, albums: albums));
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }
}
