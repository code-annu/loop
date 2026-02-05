import { Request, Response, NextFunction } from "express";
import { AppError } from "../../domain/errors";
import { errorResponse } from "../responses";
import { logger } from "../../util";

/**
 * Global error handling middleware
 */
export function errorMiddleware(
  error: Error,
  req: Request,
  res: Response,
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  next: NextFunction,
): void {
  // Log the error
  logger.error("Error occurred", {
    name: error.name,
    message: error.message,
    stack: process.env.NODE_ENV === "development" ? error.stack : undefined,
    path: req.path,
    method: req.method,
  });

  // Handle known application errors
  if (error instanceof AppError) {
    res
      .status(error.code)
      .json(errorResponse(error.type, error.message, error.code));
    return;
  }

  // Handle unexpected errors
  const statusCode = 500;
  const message =
    process.env.NODE_ENV === "production"
      ? "Internal server error"
      : error.message;

  res
    .status(statusCode)
    .json(errorResponse("InternalError", message, statusCode));
}

/**
 * 404 Not Found middleware
 */
export function notFoundMiddleware(req: Request, res: Response): void {
  res
    .status(404)
    .json(
      errorResponse(
        "NotFoundError",
        `Route ${req.method} ${req.path} not found`,
        404,
      ),
    );
}
