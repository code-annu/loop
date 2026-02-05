/**
 * Track DTOs
 */

// Input DTO for getting a track by ID
export interface GetTrackByIdInputDTO {
  id: string;
}

// Album info in track response
export interface TrackAlbumDTO {
  id: string;
  title: string;
}

// Artist info in track response
export interface TrackArtistDTO {
  id: string;
  name: string;
  profile_url: string | null;
}

// Output DTO for track response
export interface TrackOutputDTO {
  id: string;
  title: string;
  cover_url: string | null;
  track_url: string | null;
  album: TrackAlbumDTO | null;
  artists: TrackArtistDTO[];
  duration: number;
}

// Input DTO for getting random tracks
export interface GetRandomTracksInputDTO {
  limit?: number;
}

// Output DTO for random tracks
export interface GetRandomTracksOutputDTO {
  tracks: TrackOutputDTO[];
}
