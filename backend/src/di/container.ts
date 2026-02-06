import { Container } from "inversify";
import "reflect-metadata";

import { TYPES } from "./types";

// Repository interfaces
import {
  IArtistRepository,
  IAlbumRepository,
  ITrackRepository,
} from "../domain/repositories";

// Repository implementations
import {
  PrismaArtistRepository,
  PrismaAlbumRepository,
  PrismaTrackRepository,
} from "../infrastructure/repositories";

// Use cases
import {
  GetTrackByIdUseCase,
  GetRandomTracksUseCase,
  SearchTracksUseCase,
} from "../application/usecases/track";
import {
  GetAlbumByIdUseCase,
  GetRandomAlbumsUseCase,
  SearchAlbumsUseCase,
} from "../application/usecases/album";
import {
  GetArtistByIdUseCase,
  GetRandomArtistsUseCase,
} from "../application/usecases/artist";

// Controllers
import { TrackController } from "../api/controllers/TrackController";
import { AlbumController } from "../api/controllers/AlbumController";
import { ArtistController } from "../api/controllers/ArtistController";

/**
 * Create and configure the Inversify DI container
 */
function createContainer(): Container {
  const container = new Container();

  // Bind Repositories
  container
    .bind<IArtistRepository>(TYPES.ArtistRepository)
    .to(PrismaArtistRepository)
    .inSingletonScope();
  container
    .bind<IAlbumRepository>(TYPES.AlbumRepository)
    .to(PrismaAlbumRepository)
    .inSingletonScope();
  container
    .bind<ITrackRepository>(TYPES.TrackRepository)
    .to(PrismaTrackRepository)
    .inSingletonScope();

  // Bind Track Use Cases
  container
    .bind<GetTrackByIdUseCase>(TYPES.GetTrackByIdUseCase)
    .to(GetTrackByIdUseCase)
    .inSingletonScope();
  container
    .bind<GetRandomTracksUseCase>(TYPES.GetRandomTracksUseCase)
    .to(GetRandomTracksUseCase)
    .inSingletonScope();
  container
    .bind<SearchTracksUseCase>(TYPES.SearchTracksUseCase)
    .to(SearchTracksUseCase)
    .inSingletonScope();

  // Bind Album Use Cases
  container
    .bind<GetAlbumByIdUseCase>(TYPES.GetAlbumByIdUseCase)
    .to(GetAlbumByIdUseCase)
    .inSingletonScope();
  container
    .bind<GetRandomAlbumsUseCase>(TYPES.GetRandomAlbumsUseCase)
    .to(GetRandomAlbumsUseCase)
    .inSingletonScope();
  container
    .bind<SearchAlbumsUseCase>(TYPES.SearchAlbumsUseCase)
    .to(SearchAlbumsUseCase)
    .inSingletonScope();

  // Bind Artist Use Cases
  container
    .bind<GetArtistByIdUseCase>(TYPES.GetArtistByIdUseCase)
    .to(GetArtistByIdUseCase)
    .inSingletonScope();
  container
    .bind<GetRandomArtistsUseCase>(TYPES.GetRandomArtistsUseCase)
    .to(GetRandomArtistsUseCase)
    .inSingletonScope();

  // Bind Controllers
  container
    .bind<TrackController>(TYPES.TrackController)
    .to(TrackController)
    .inSingletonScope();
  container
    .bind<AlbumController>(TYPES.AlbumController)
    .to(AlbumController)
    .inSingletonScope();
  container
    .bind<ArtistController>(TYPES.ArtistController)
    .to(ArtistController)
    .inSingletonScope();

  return container;
}

export const container = createContainer();
