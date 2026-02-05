type LogLevel = "info" | "warn" | "error" | "debug";

interface LogMessage {
  level: LogLevel;
  message: string;
  timestamp: string;
  data?: unknown;
}

/**
 * Simple console logger utility
 */
class Logger {
  private formatMessage(log: LogMessage): string {
    const dataStr = log.data ? ` | ${JSON.stringify(log.data)}` : "";
    return `[${log.timestamp}] [${log.level.toUpperCase()}] ${log.message}${dataStr}`;
  }

  private log(level: LogLevel, message: string, data?: unknown): void {
    const logMessage: LogMessage = {
      level,
      message,
      timestamp: new Date().toISOString(),
      data,
    };

    const formatted = this.formatMessage(logMessage);

    switch (level) {
      case "info":
        console.info(formatted);
        break;
      case "warn":
        console.warn(formatted);
        break;
      case "error":
        console.error(formatted);
        break;
      case "debug":
        if (process.env.NODE_ENV === "development") {
          console.debug(formatted);
        }
        break;
    }
  }

  info(message: string, data?: unknown): void {
    this.log("info", message, data);
  }

  warn(message: string, data?: unknown): void {
    this.log("warn", message, data);
  }

  error(message: string, data?: unknown): void {
    this.log("error", message, data);
  }

  debug(message: string, data?: unknown): void {
    this.log("debug", message, data);
  }
}

export const logger = new Logger();
