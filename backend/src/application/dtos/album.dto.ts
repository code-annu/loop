/**
 * Album DTOs
 */

// Input DTO for getting an album by ID
export interface GetAlbumByIdInputDTO {
  id: string;
}

// Track info in album response
export interface AlbumTrackDTO {
  id: string;
  title: string;
  cover_url: string | null;
  track_url: string | null;
  duration: number;
}

// Artist info in album response
export interface AlbumArtistDTO {
  id: string;
  name: string;
  profile_url: string | null;
}

// Output DTO for album response
export interface AlbumOutputDTO {
  id: string;
  title: string;
  cover_url: string | null;
  tracks: AlbumTrackDTO[];
  artists: AlbumArtistDTO[];
}

// Input DTO for getting random albums
export interface GetRandomAlbumsInputDTO {
  limit?: number;
}

// Output DTO for random albums
export interface GetRandomAlbumsOutputDTO {
  albums: AlbumOutputDTO[];
}
