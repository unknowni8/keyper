import 'package:app_logger/app_logger.dart';
import 'package:call_log/call_log.dart' as call_log_package;
import 'package:call_log_repository/src/models/call_log.dart';
import 'package:permission_client/permission_client.dart';

/// Repository for call log data operations
class CallLogRepository {
  final PermissionClient _permissionClient;

  CallLogRepository({required PermissionClient permissionClient})
    : _permissionClient = permissionClient;

  /// Check if call log permission is available
  Future<bool> hasPermission() async {
    try {
      final status = await _permissionClient.phoneStatus();
      return status.isGranted;
    } catch (e) {
      return false;
    }
  }

  /// Request call log permission
  Future<bool> requestPermission() async {
    try {
      final status = await _permissionClient.requestPhone();
      final granted = status.isGranted;
      return granted;
    } catch (e) {
      AppLogger.error(
        'Error requesting call log permission',
        tag: 'CALL_LOG_REPO',
        error: e,
      );
      return false;
    }
  }

  /// Fetch call logs with pagination (20 records at a time)
  Future<List<CallLog>> fetchCallLogs() async {
    try {
      // Check permission first
      if (!await hasPermission()) {
        final granted = await requestPermission();
        if (!granted) {
          return [];
        }
      }
      // Fetch call logs from device
      final entries = await call_log_package.CallLog.query(
        dateFrom: null,
        dateTo: null,
        durationFrom: null,
        durationTo: null,
        name: null,
        number: null,
        type: null,
      );

      if (entries.isEmpty) {
        return [];
      }

      return entries
          .map((entry) => CallLog.fromCallLogEntry(entry))
          .toList();
    } catch (e) {
      AppLogger.error(
        'Error fetching call logs',
        tag: 'CALL_LOG_REPO',
        error: e,
      );
      return [];
    }
  }

  /// Get total count of call logs
  Future<int> getTotalCount() async {
    try {
      if (!await hasPermission()) {
        return 0;
      }

      final entries = await call_log_package.CallLog.query();
      return entries.length;
    } catch (e) {
      AppLogger.error(
        'Error getting call log count',
        tag: 'CALL_LOG_REPO',
        error: e,
      );
      return 0;
    }
  }

  /// Fetch call logs by type
  Future<List<CallLog>> fetchCallLogsByType({
    required call_log_package.CallType callType,
  }) async {
    try {
      if (!await hasPermission()) {
        final granted = await requestPermission();
        if (!granted) {
          return [];
        }
      }

      final entries = await call_log_package.CallLog.query(type: callType);

      if (entries.isEmpty) return [];

      return entries
          .map((entry) => CallLog.fromCallLogEntry(entry))
          .toList();
    } catch (e) {
      AppLogger.error(
        'Error fetching call logs by type',
        tag: 'CALL_LOG_REPO',
        error: e,
      );
      return [];
    }
  }

  /// Search call logs with pagination
  Future<List<CallLog>> searchCallLogs({
    required String query,
  }) async {
    try {
      if (!await hasPermission()) {
        final granted = await requestPermission();
        if (!granted) {
          return [];
        }
      }

      // Fetch all entries and filter manually since the package has limited search
      final entries = await call_log_package.CallLog.query();
      if (entries.isEmpty) return [];

      final filteredEntries = entries.where((entry) {
        final name = entry.name?.toLowerCase() ?? '';
        final number = entry.number?.toLowerCase() ?? '';
        final searchQuery = query.toLowerCase();

        return name.contains(searchQuery) || number.contains(searchQuery);
      }).toList();

      return filteredEntries
          .map((entry) => CallLog.fromCallLogEntry(entry))
          .toList();
    } catch (e) {
      AppLogger.error('Error searching call logs', tag: 'CALL_LOG_REPO', error: e);
      return [];
    }
  }

  /// Get call logs statistics
  Future<CallLogStats> getCallLogStats() async {
    try {
      if (!await hasPermission()) {
        return CallLogStats.empty();
      }

      final allLogs = await fetchCallLogs(); // Get more for stats

      int incoming = 0;
      int outgoing = 0;
      int missed = 0;
      int rejected = 0;
      int totalDuration = 0;
      int blocked = 0;
      int voicemail = 0;

      for (final log in allLogs) {
        switch (log.callType) {
          case call_log_package.CallType.wifiIncoming:
          case call_log_package.CallType.incoming:
            incoming++;
            break;
          case call_log_package.CallType.wifiOutgoing:
          case call_log_package.CallType.outgoing:
            outgoing++;
            break;
          case call_log_package.CallType.missed:
            missed++;
            break;
          case call_log_package.CallType.rejected:
            rejected++;
            break;
          case call_log_package.CallType.answeredExternally:
          case call_log_package.CallType.unknown:
            break;
          case call_log_package.CallType.voiceMail:
            voicemail++;
            break;
          case call_log_package.CallType.blocked:
            blocked++;
            break;
        }
        totalDuration += log.duration ?? 0;
      }

      return CallLogStats(
        total: allLogs.length,
        incoming: incoming,
        outgoing: outgoing,
        missed: missed,
        rejected: rejected,
        totalDuration: totalDuration,
        blocked: blocked,
        voicemail: voicemail,
      );
    } catch (e) {
      return CallLogStats.empty();
    }
  }
}