import { Track } from "../entities/Track";

/**
 * Track Repository Interface
 * Defines the contract for track data access
 */
export interface ITrackRepository {
  /**
   * Find a track by ID with album and artists
   * @param id - Track ID
   * @returns Track entity or null if not found
   */
  findById(id: string): Promise<Track | null>;

  /**
   * Get random tracks with album and artists
   * @param limit - Maximum number of tracks to return
   * @returns Array of track entities
   */
  findRandom(limit: number): Promise<Track[]>;

  /**
   * Get all tracks
   * @returns Array of all track entities
   */
  findAll(): Promise<Track[]>;

  /**
   * Get tracks by album ID
   * @param albumId - Album ID
   * @returns Array of track entities
   */
  findByAlbumId(albumId: string): Promise<Track[]>;
}
