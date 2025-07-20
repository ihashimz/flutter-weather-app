import 'package:flutter/foundation.dart';

enum LogLevel {
  debug,
  info,
  warning,
  error,
}

class LoggerService {
  static void log(String message, {LogLevel level = LogLevel.info}) {
    if (kDebugMode) {
      final timestamp = DateTime.now().toString();
      final levelStr = level.name.toUpperCase();
      debugPrint('[$timestamp] [$levelStr] $message');
    }
  }
  
  static void debug(String message) {
    log(message, level: LogLevel.debug);
  }
  
  static void info(String message) {
    log(message, level: LogLevel.info);
  }
  
  static void warning(String message) {
    log(message, level: LogLevel.warning);
  }
  
  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    log('$message${error != null ? ' - Error: $error' : ''}', level: LogLevel.error);
    if (stackTrace != null && kDebugMode) {
      debugPrint('Stack trace: $stackTrace');
    }
  }
}