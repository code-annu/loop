import { z } from "zod";

/**
 * Track ID parameter schema
 */
export const trackIdParamSchema = z.object({
  id: z.string().uuid("Invalid track ID format"),
});

/**
 * Random tracks query schema
 */
export const randomTracksQuerySchema = z.object({
  limit: z
    .string()
    .optional()
    .transform((val) => (val ? parseInt(val, 10) : undefined))
    .pipe(z.number().min(1).max(50).optional()),
});

// Type exports
export type TrackIdParam = z.infer<typeof trackIdParamSchema>;
export type RandomTracksQuery = z.infer<typeof randomTracksQuerySchema>;
