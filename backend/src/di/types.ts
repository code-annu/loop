/**
 * Inversify DI Type Symbols
 */
export const TYPES = {
  // Repositories
  ArtistRepository: Symbol.for("ArtistRepository"),
  AlbumRepository: Symbol.for("AlbumRepository"),
  TrackRepository: Symbol.for("TrackRepository"),

  // Use Cases - Track
  GetTrackByIdUseCase: Symbol.for("GetTrackByIdUseCase"),
  GetRandomTracksUseCase: Symbol.for("GetRandomTracksUseCase"),
  SearchTracksUseCase: Symbol.for("SearchTracksUseCase"),

  // Use Cases - Album
  GetAlbumByIdUseCase: Symbol.for("GetAlbumByIdUseCase"),
  GetRandomAlbumsUseCase: Symbol.for("GetRandomAlbumsUseCase"),
  SearchAlbumsUseCase: Symbol.for("SearchAlbumsUseCase"),

  // Use Cases - Artist
  GetArtistByIdUseCase: Symbol.for("GetArtistByIdUseCase"),
  GetRandomArtistsUseCase: Symbol.for("GetRandomArtistsUseCase"),

  // Controllers
  TrackController: Symbol.for("TrackController"),
  AlbumController: Symbol.for("AlbumController"),
  ArtistController: Symbol.for("ArtistController"),
};
