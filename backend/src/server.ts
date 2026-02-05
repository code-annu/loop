import "reflect-metadata";
import express, { Application } from "express";
import cors from "cors";
import dotenv from "dotenv";

// Load environment variables
dotenv.config();

import routes from "./api/routes";
import { errorMiddleware, notFoundMiddleware } from "./api/middleware";
import { logger } from "./util";
import { disconnectPrisma } from "./infrastructure/database/prisma-client";

/**
 * Create and configure Express application
 */
function createApp(): Application {
  const app = express();

  // Middleware
  app.use(cors());
  app.use(express.json());
  app.use(express.urlencoded({ extended: true }));

  // Request logging in development
  if (process.env.NODE_ENV === "development") {
    app.use((req, res, next) => {
      logger.debug(`${req.method} ${req.path}`);
      next();
    });
  }

  // Routes
  app.use(routes);

  // Error handling
  app.use(notFoundMiddleware);
  app.use(errorMiddleware);

  return app;
}

/**
 * Start the server
 */
async function startServer(): Promise<void> {
  const app = createApp();
  const PORT = process.env.PORT || 3000;

  const server = app.listen(PORT, () => {
    logger.info(`🎵 Loop API server running on port ${PORT}`);
    logger.info(`   Environment: ${process.env.NODE_ENV || "development"}`);
    logger.info(`   Health check: http://localhost:${PORT}/health`);
  });

  // Graceful shutdown
  const shutdown = async (signal: string) => {
    logger.info(`${signal} received. Shutting down gracefully...`);

    server.close(async () => {
      logger.info("HTTP server closed");
      await disconnectPrisma();
      logger.info("Database connection closed");
      process.exit(0);
    });

    // Force shutdown after 10 seconds
    setTimeout(() => {
      logger.error("Forced shutdown after timeout");
      process.exit(1);
    }, 10000);
  };

  process.on("SIGTERM", () => shutdown("SIGTERM"));
  process.on("SIGINT", () => shutdown("SIGINT"));
}

// Start the server
startServer().catch((error) => {
  logger.error("Failed to start server", error);
  process.exit(1);
});
