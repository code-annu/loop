import { Album } from "../entities/Album";

/**
 * Album Repository Interface
 * Defines the contract for album data access
 */
export interface IAlbumRepository {
  /**
   * Find an album by ID with tracks and artists
   * @param id - Album ID
   * @returns Album entity or null if not found
   */
  findById(id: string): Promise<Album | null>;

  /**
   * Get random albums with artists
   * @param limit - Maximum number of albums to return
   * @returns Array of album entities
   */
  findRandom(limit: number): Promise<Album[]>;

  /**
   * Get all albums
   * @returns Array of all album entities
   */
  findAll(): Promise<Album[]>;
}
