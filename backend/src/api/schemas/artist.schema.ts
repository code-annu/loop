import { z } from "zod";

/**
 * Artist ID parameter schema
 */
export const artistIdParamSchema = z.object({
  id: z.string().uuid("Invalid artist ID format"),
});

/**
 * Random artists query schema
 */
export const randomArtistsQuerySchema = z.object({
  limit: z
    .string()
    .optional()
    .transform((val) => (val ? parseInt(val, 10) : undefined))
    .pipe(z.number().min(1).max(50).optional()),
});

// Type exports
export type ArtistIdParam = z.infer<typeof artistIdParamSchema>;
export type RandomArtistsQuery = z.infer<typeof randomArtistsQuerySchema>;
