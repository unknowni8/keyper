import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:logger/logger.dart';
import 'dart:io';

/// Advanced logging service with file output and performance tracking
class AppLoggerConfig {
  static AppLoggerConfig? _instance;
  static AppLoggerConfig get instance {
    _instance ??= AppLoggerConfig._internal();
    return _instance!;
  }

  AppLoggerConfig._internal();

  late Logger _logger;
  File? _logFile;
  final List<LogEntry> _logBuffer = [];
  static const int _maxBufferSize = 1000;

  /// Initialize the logging service
  Future<void> initialize() async {
    _logger = _createLogger();

    // Set up file logging for non-debug modes
    if (!kDebugMode) {
      await _setupFileLogging();
    }
  }

    /// Create logger based on current build mode
  Logger _createLogger() {
    if (kDebugMode) {
      // Debug mode: Verbose logging with console output
      return Logger(
        printer: PrettyPrinter(
          methodCount: 0,
          errorMethodCount: 8,
          lineLength: 120,
          colors: true,
          printEmojis: true,
          dateTimeFormat: DateTimeFormat.none,
        ),
        level: Level.debug,
      );
    } else if (kProfileMode) {
      // Profile mode: Moderate logging for performance monitoring
      return Logger(printer: SimplePrinter(), level: Level.info);
    } else {
      // Release mode: Minimal logging, errors only
      return Logger(printer: SimplePrinter(), level: Level.error);
    }
  }

  /// Set up file logging
  Future<void> _setupFileLogging() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final logDir = Directory('${directory.path}/logs');

      if (!await logDir.exists()) {
        await logDir.create(recursive: true);
      }

      final timestamp = DateTime.now().toIso8601String().split('T')[0];
      _logFile = File('${logDir.path}/keyper_$timestamp.log');
    } catch (e) {
      _logger.e('Failed to setup file logging: $e');
    }
  }

  /// Log a message with automatic level detection
  void log(
    String message, {
    LogLevel level = LogLevel.info,
    String? tag,
    dynamic error,
    StackTrace? stackTrace,
    Map<String, dynamic>? extra,
  }) {
    // Automatically capture stack trace for error and fatal logs
    final capturedStackTrace =
        stackTrace ??
        (level == LogLevel.error || level == LogLevel.fatal
            ? StackTrace.current
            : null);

    final entry = LogEntry(
      timestamp: DateTime.now(),
      level: level,
      message: message,
      tag: tag,
      error: error,
      stackTrace: capturedStackTrace,
      extra: extra,
    );

    _logBuffer.add(entry);

    // Maintain buffer size
    if (_logBuffer.length > _maxBufferSize) {
      _logBuffer.removeAt(0);
    }

    // Log to console/file based on level and mode
    _writeLog(entry);
  }

  /// Write log entry to appropriate outputs
  void _writeLog(LogEntry entry) {
    final formattedMessage = _formatMessage(entry);

    // Console logging
    switch (entry.level) {
      case LogLevel.debug:
        if (kDebugMode) {
          _logger.d(
            formattedMessage,
            error: entry.error,
            stackTrace: entry.stackTrace,
          );
        }
        break;
      case LogLevel.info:
        if (kDebugMode || kProfileMode) {
          _logger.i(
            formattedMessage,
            error: entry.error,
            stackTrace: entry.stackTrace,
          );
        }
        break;
      case LogLevel.warning:
        _logger.w(
          formattedMessage,
          error: entry.error,
          stackTrace: entry.stackTrace,
        );
        break;
      case LogLevel.error:
        _logger.e(
          formattedMessage,
          error: entry.error,
          stackTrace: entry.stackTrace,
        );
        break;
      case LogLevel.fatal:
        _logger.f(
          formattedMessage,
          error: entry.error,
          stackTrace: entry.stackTrace,
        );
        break;
    }

    // File logging for non-debug modes
    if (!kDebugMode && _logFile != null) {
      _writeToFile(formattedMessage);
    }
  }

  /// Format log message
  String _formatMessage(LogEntry entry) {
    final buffer = StringBuffer();
    buffer.write('[${entry.timestamp.toIso8601String()}] ');
    buffer.write('[${entry.level.name.toUpperCase()}] ');

    if (entry.tag != null) {
      buffer.write('[${entry.tag}] ');
    }

    buffer.write(entry.message);

    if (entry.extra != null && entry.extra!.isNotEmpty) {
      buffer.write(' | Extra: ${entry.extra}');
    }

    return buffer.toString();
  }

  /// Write to log file
  void _writeToFile(String message) {
    try {
      _logFile!.writeAsStringSync('$message\n', mode: FileMode.append);
    } catch (e) {
      // Avoid recursive logging
      debugPrint('Failed to write to log file: $e');
    }
  }

  /// API call logging
  void logApiCall(
    String method,
    String url,
    int statusCode,
    Duration duration, {
    String? body,
  }) {
    final level = statusCode >= 400 ? LogLevel.error : LogLevel.info;
    log(
      'API $method $url -> $statusCode (${duration.inMilliseconds}ms)',
      level: level,
      tag: 'API',
      extra: body != null ? {'body': body} : null,
    );
  }

  /// User action logging
  void logUserAction(String action, {Map<String, dynamic>? context}) {
    log(
      'User action: $action',
      level: LogLevel.info,
      tag: 'USER_ACTION',
      extra: context,
    );
  }

  /// Get recent log entries
  List<LogEntry> getRecentLogs({int count = 50}) {
    final start = _logBuffer.length > count ? _logBuffer.length - count : 0;
    return _logBuffer.sublist(start);
  }

  /// Clear log buffer
  void clearLogs() {
    _logBuffer.clear();
  }

  /// Get log file path
  String? get logFilePath => _logFile?.path;
}

/// Log entry model
class LogEntry {
  final DateTime timestamp;
  final LogLevel level;
  final String message;
  final String? tag;
  final dynamic error;
  final StackTrace? stackTrace;
  final Map<String, dynamic>? extra;

  LogEntry({
    required this.timestamp,
    required this.level,
    required this.message,
    this.tag,
    this.error,
    this.stackTrace,
    this.extra,
  });
}

/// Log levels
enum LogLevel { debug, info, warning, error, fatal }

/// Convenience methods for common logging patterns
class AppLogger {
  static void debug(
    String message, {
    String? tag,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    AppLoggerConfig.instance.log(
      message,
      level: LogLevel.debug,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
    );
  }

  static void info(
    String message, {
    String? tag,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    AppLoggerConfig.instance.log( 
      message,
      level: LogLevel.info,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
    );
  }

  static void warning(
    String message, {
    String? tag,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    AppLoggerConfig.instance.log(
      message,
      level: LogLevel.warning,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
    );
  }

  static void error(
    String message, {
    String? tag,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    AppLoggerConfig.instance.log(
      message,
      level: LogLevel.error,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
    );
  }

  static void fatal(
    String message, {
    String? tag,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    AppLoggerConfig.instance.log( 
      message,
      level: LogLevel.fatal,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
    );
  }

  static void apiCall(
    String method,
    String url,
    int statusCode,
    Duration duration, {
    String? body,
  }) {
    AppLoggerConfig.instance.logApiCall(
      method,
      url,
      statusCode,
      duration,
      body: body,
    );
  }

  static void userAction(String action, {Map<String, dynamic>? context}) {
    AppLoggerConfig.instance.logUserAction(action, context: context);
  }
}
