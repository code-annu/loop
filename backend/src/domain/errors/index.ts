/**
 * Base Application Error
 */
export abstract class AppError extends Error {
  abstract readonly type: string;
  abstract readonly code: number;

  constructor(message: string) {
    super(message);
    this.name = this.constructor.name;
    Error.captureStackTrace(this, this.constructor);
  }

  toJSON() {
    return {
      type: this.type,
      message: this.message,
    };
  }
}

/**
 * Not Found Error - 404
 */
export class NotFoundError extends AppError {
  readonly type = "NotFoundError";
  readonly code = 404;

  constructor(message: string = "Resource not found") {
    super(message);
  }
}

/**
 * Authentication Error - 401
 */
export class AuthenticationError extends AppError {
  readonly type = "AuthenticationError";
  readonly code = 401;

  constructor(message: string = "Authentication required") {
    super(message);
  }
}

/**
 * Forbidden Error - 403
 */
export class ForbiddenError extends AppError {
  readonly type = "ForbiddenError";
  readonly code = 403;

  constructor(message: string = "Access forbidden") {
    super(message);
  }
}

/**
 * Validation Error - 400
 */
export class ValidationError extends AppError {
  readonly type = "ValidationError";
  readonly code = 400;

  constructor(message: string = "Validation failed") {
    super(message);
  }
}

/**
 * Internal Server Error - 500
 */
export class InternalError extends AppError {
  readonly type = "InternalError";
  readonly code = 500;

  constructor(message: string = "Internal server error") {
    super(message);
  }
}
