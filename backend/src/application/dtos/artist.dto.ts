/**
 * Artist DTOs
 */

// Input DTO for getting an artist by ID
export interface GetArtistByIdInputDTO {
  id: string;
}

// Output DTO for artist response
export interface ArtistOutputDTO {
  id: string;
  name: string;
  profile_url: string | null;
}

// Input DTO for getting random artists
export interface GetRandomArtistsInputDTO {
  limit?: number;
}

// Output DTO for random artists
export interface GetRandomArtistsOutputDTO {
  artists: ArtistOutputDTO[];
}
