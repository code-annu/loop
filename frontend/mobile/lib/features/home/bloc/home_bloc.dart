import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/repositories.dart';
import '../../../core/errors/app_exception.dart';
import 'home_event.dart';
import 'home_state.dart';

/// Home Bloc
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final TrackRepository _trackRepository;
  final AlbumRepository _albumRepository;

  HomeBloc({
    TrackRepository? trackRepository,
    AlbumRepository? albumRepository,
  })  : _trackRepository = trackRepository ?? TrackRepository(),
        _albumRepository = albumRepository ?? AlbumRepository(),
        super(const HomeInitial()) {
    on<FetchHomeData>(_onFetchHomeData);
    on<FetchQuickPicks>(_onFetchQuickPicks);
    on<FetchRandomPicks>(_onFetchRandomPicks);
    on<FetchNewAlbums>(_onFetchNewAlbums);
  }

  Future<void> _onFetchHomeData(
    FetchHomeData event,
    Emitter<HomeState> emit,
  ) async {
    emit(const HomeLoading());

    try {
      // Fetch all data concurrently
      final quickPicks = await _trackRepository.getRandomTracks(limit: 10);
      final randomPicks = await _trackRepository.getRandomTracks(limit: 10);
      final newAlbums = await _albumRepository.getRandomAlbums(limit: 10);

      emit(HomeLoaded(
        quickPicks: quickPicks,
        randomPicks: randomPicks,
        newAlbums: newAlbums,
      ));
    } on AppException catch (e) {
      emit(HomeError(e.message));
    } catch (e) {
      emit(HomeError('An unexpected error occurred'));
    }
  }

  Future<void> _onFetchQuickPicks(
    FetchQuickPicks event,
    Emitter<HomeState> emit,
  ) async {
    final currentState = state;
    
    try {
      final tracks = await _trackRepository.getRandomTracks(limit: 10);
      
      if (currentState is HomeLoaded) {
        emit(currentState.copyWith(quickPicks: tracks));
      } else {
        emit(HomeLoaded(quickPicks: tracks));
      }
    } on AppException catch (e) {
      emit(HomeError(e.message));
    }
  }

  Future<void> _onFetchRandomPicks(
    FetchRandomPicks event,
    Emitter<HomeState> emit,
  ) async {
    final currentState = state;
    
    try {
      final tracks = await _trackRepository.getRandomTracks(limit: 10);
      
      if (currentState is HomeLoaded) {
        emit(currentState.copyWith(randomPicks: tracks));
      } else {
        emit(HomeLoaded(randomPicks: tracks));
      }
    } on AppException catch (e) {
      emit(HomeError(e.message));
    }
  }

  Future<void> _onFetchNewAlbums(
    FetchNewAlbums event,
    Emitter<HomeState> emit,
  ) async {
    final currentState = state;
    
    try {
      final albums = await _albumRepository.getRandomAlbums(limit: 10);
      
      if (currentState is HomeLoaded) {
        emit(currentState.copyWith(newAlbums: albums));
      } else {
        emit(HomeLoaded(newAlbums: albums));
      }
    } on AppException catch (e) {
      emit(HomeError(e.message));
    }
  }
}
