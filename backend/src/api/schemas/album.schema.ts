import { z } from "zod";

/**
 * Album ID parameter schema
 */
export const albumIdParamSchema = z.object({
  id: z.string().uuid("Invalid album ID format"),
});

/**
 * Random albums query schema
 */
export const randomAlbumsQuerySchema = z.object({
  limit: z
    .string()
    .optional()
    .transform((val) => (val ? parseInt(val, 10) : undefined))
    .pipe(z.number().min(1).max(50).optional()),
});

// Type exports
export type AlbumIdParam = z.infer<typeof albumIdParamSchema>;
export type RandomAlbumsQuery = z.infer<typeof randomAlbumsQuerySchema>;
