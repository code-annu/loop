import { Artist } from "../entities/Artist";

/**
 * Artist Repository Interface
 * Defines the contract for artist data access
 */
export interface IArtistRepository {
  /**
   * Find an artist by ID
   * @param id - Artist ID
   * @returns Artist entity or null if not found
   */
  findById(id: string): Promise<Artist | null>;

  /**
   * Get random artists
   * @param limit - Maximum number of artists to return
   * @returns Array of artist entities
   */
  findRandom(limit: number): Promise<Artist[]>;

  /**
   * Get all artists
   * @returns Array of all artist entities
   */
  findAll(): Promise<Artist[]>;
}
