import { Router } from "express";
import trackRoutes from "./track.routes";
import albumRoutes from "./album.routes";
import artistRoutes from "./artist.routes";

const router = Router();

// API version prefix
const API_PREFIX = "/api/v1";

// Mount routes
router.use(`${API_PREFIX}/tracks`, trackRoutes);
router.use(`${API_PREFIX}/albums`, albumRoutes);
router.use(`${API_PREFIX}/artists`, artistRoutes);

// Health check endpoint
router.get("/health", (req, res) => {
  res.status(200).json({
    status: "success",
    code: 200,
    data: {
      message: "Loop API is running",
      timestamp: new Date().toISOString(),
    },
  });
});

export default router;
