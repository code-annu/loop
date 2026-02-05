/**
 * Standardized API Response formats
 */

export interface SuccessResponse<T> {
  status: "success";
  code: number;
  data: T;
}

export interface ErrorResponse {
  status: "failed";
  code: number;
  error: {
    type: string;
    message: string;
  };
}

export type ApiResponse<T> = SuccessResponse<T> | ErrorResponse;

/**
 * Create a success response
 */
export function successResponse<T>(
  data: T,
  code: number = 200,
): SuccessResponse<T> {
  return {
    status: "success",
    code,
    data,
  };
}

/**
 * Create an error response
 */
export function errorResponse(
  type: string,
  message: string,
  code: number = 500,
): ErrorResponse {
  return {
    status: "failed",
    code,
    error: {
      type,
      message,
    },
  };
}
