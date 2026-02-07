import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/album_repository.dart';
import '../../../core/errors/app_exception.dart';
import 'album_event.dart';
import 'album_state.dart';

class AlbumBloc extends Bloc<AlbumEvent, AlbumState> {
  final AlbumRepository _albumRepository;

  AlbumBloc({AlbumRepository? albumRepository})
    : _albumRepository = albumRepository ?? AlbumRepository(),
      super(AlbumInitial()) {
    on<LoadAlbum>(_onLoadAlbum);
  }

  Future<void> _onLoadAlbum(LoadAlbum event, Emitter<AlbumState> emit) async {
    emit(AlbumLoading());
    try {
      final album = await _albumRepository.getAlbumById(event.albumId);
      emit(AlbumLoaded(album));
    } catch (e) {
      if (e is AppException) {
        emit(AlbumError(e.message));
      } else {
        emit(AlbumError(e.toString()));
      }
    }
  }
}
