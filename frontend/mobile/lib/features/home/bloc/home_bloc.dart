import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/repositories.dart';
import '../../../core/errors/app_exception.dart';
import 'home_event.dart';
import 'home_state.dart';

/// Home Bloc
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final TrackRepository _trackRepository;
  final AlbumRepository _albumRepository;

  HomeBloc({TrackRepository? trackRepository, AlbumRepository? albumRepository})
    : _trackRepository = trackRepository ?? TrackRepository(),
      _albumRepository = albumRepository ?? AlbumRepository(),
      super(const HomeState()) {
    on<FetchHomeData>(_onFetchHomeData);
    on<FetchQuickPicks>(_onFetchQuickPicks);
    on<FetchRandomPicks>(_onFetchRandomPicks);
    on<FetchNewAlbums>(_onFetchNewAlbums);
    on<FetchTracks>(_onFetchTracks);
  }

  void _onFetchHomeData(FetchHomeData event, Emitter<HomeState> emit) {
    add(const FetchQuickPicks());
    add(const FetchNewAlbums());
    add(const FetchRandomPicks());
    add(const FetchTracks());
  }

  Future<void> _onFetchQuickPicks(
    FetchQuickPicks event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(quickPicksStatus: HomeSectionStatus.loading));

    try {
      final tracks = await _trackRepository.getRandomTracks(limit: 10);
      emit(
        state.copyWith(
          quickPicksStatus: HomeSectionStatus.loaded,
          quickPicks: tracks,
        ),
      );
    } on AppException catch (e) {
      emit(
        state.copyWith(
          quickPicksStatus: HomeSectionStatus.error,
          errorMessage: e.message,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          quickPicksStatus: HomeSectionStatus.error,
          errorMessage: 'Failed to load quick picks',
        ),
      );
    }
  }

  Future<void> _onFetchRandomPicks(
    FetchRandomPicks event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(randomPicksStatus: HomeSectionStatus.loading));

    try {
      final tracks = await _trackRepository.getRandomTracks(limit: 10);
      emit(
        state.copyWith(
          randomPicksStatus: HomeSectionStatus.loaded,
          randomPicks: tracks,
        ),
      );
    } on AppException catch (e) {
      emit(
        state.copyWith(
          randomPicksStatus: HomeSectionStatus.error,
          errorMessage: e.message,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          randomPicksStatus: HomeSectionStatus.error,
          errorMessage: 'Failed to load random picks',
        ),
      );
    }
  }

  Future<void> _onFetchNewAlbums(
    FetchNewAlbums event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(newAlbumsStatus: HomeSectionStatus.loading));

    try {
      final albums = await _albumRepository.getRandomAlbums(limit: 10);
      emit(
        state.copyWith(
          newAlbumsStatus: HomeSectionStatus.loaded,
          newAlbums: albums,
        ),
      );
    } on AppException catch (e) {
      emit(
        state.copyWith(
          newAlbumsStatus: HomeSectionStatus.error,
          errorMessage: e.message,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          newAlbumsStatus: HomeSectionStatus.error,
          errorMessage: 'Failed to load new albums',
        ),
      );
    }
  }

  Future<void> _onFetchTracks(
    FetchTracks event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(tracksStatus: HomeSectionStatus.loading));

    try {
      // Using existing method for now, but ideally this would be a specific endpoint if available
      // or just another random set for variety if specific API doesn't exist yet
      final tracks = await _trackRepository.getRandomTracks(limit: 10);
      emit(
        state.copyWith(tracksStatus: HomeSectionStatus.loaded, tracks: tracks),
      );
    } on AppException catch (e) {
      emit(
        state.copyWith(
          tracksStatus: HomeSectionStatus.error,
          errorMessage: e.message,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          tracksStatus: HomeSectionStatus.error,
          errorMessage: 'Failed to load tracks',
        ),
      );
    }
  }
}
