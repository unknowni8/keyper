import 'package:call_log/call_log.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Represents a call log entry from the device
class CallLog extends Equatable {

  const CallLog({
    this.name,
    this.number,
    this.timestamp,
    this.duration,
    required this.callType,
    this.cachedNumberType,
    this.cachedNumberLabel,
    this.cachedMatchedNumber,
  });

  /// Create CallLogModel from call_log package CallLogEntry
  factory CallLog.fromCallLogEntry(dynamic entry) {
    return CallLog(  
      name: entry.name,
      number: entry.number,
      timestamp: entry.timestamp != null 
          ? DateTime.fromMillisecondsSinceEpoch(entry.timestamp!)
          : null,
      duration: entry.duration,
      callType: _mapCallType(entry.callType),
      cachedNumberType: entry.cachedNumberType?.toString(),
      cachedNumberLabel: entry.cachedNumberLabel,
      cachedMatchedNumber: entry.cachedMatchedNumber,
    );
  }

  /// Create CallLogModel from Map (database)
  factory CallLog.fromMap(Map<String, dynamic> map) {
    return CallLog(
      name: map['name'] as String?,
      number: map['number'] as String?,
      timestamp: map['timestamp'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int)
          : null,
      duration: map['duration'] as int?,
      callType: CallType.values[map['call_type'] as int? ?? CallType.unknown.index],
      cachedNumberType: map['cached_number_type'] as String?,
      cachedNumberLabel: map['cached_number_label'] as String?,
      cachedMatchedNumber: map['cached_matched_number'] as String?,
    );
  }
  final String? name;
  final String? number;
  final DateTime? timestamp;
  final int? duration;
  final CallType callType;
  final String? cachedNumberType;
  final String? cachedNumberLabel;
  final String? cachedMatchedNumber;

  /// Map call_log package CallType to our enum
  static CallType _mapCallType(dynamic callType) {  
    switch (callType?.toString()) {
      case 'CallType.incoming':
        return CallType.incoming;
      case 'CallType.outgoing':
        return CallType.outgoing;
      case 'CallType.missed':
        return CallType.missed;
      case 'CallType.rejected':
        return CallType.rejected;   
      default:
        return CallType.unknown;
    }
  }

  /// Format duration as human readable string
  String get formattedDuration {
    if (duration == null || duration == 0) return '0s';
    
    final minutes = duration! ~/ 60;
    final seconds = duration! % 60;
    
    if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    }
    return '${seconds}s';
  }

  /// Format timestamp as human readable string
  String get formattedTime {
    if (timestamp == null) return 'Unknown';
    
    final now = DateTime.now();
    final difference = now.difference(timestamp!);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  /// Display name or number
  String get displayName => name?.isNotEmpty == true ? name! : (number ?? 'Unknown');

  /// Convert CallLog to Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'number': number,
      'timestamp': timestamp?.millisecondsSinceEpoch,
      'duration': duration,
      'call_type': callType.index,
      'cached_number_type': cachedNumberType,
      'cached_number_label': cachedNumberLabel,
      'cached_matched_number': cachedMatchedNumber,
    };
  }

  @override
  List<Object?> get props => [
        name,
        number,
        timestamp,
        duration,
        callType,
        cachedNumberType,
        cachedNumberLabel,
        cachedMatchedNumber,
      ];
}

/// Call log statistics model
class CallLogStats {
  final int total;
  final int incoming;
  final int outgoing;
  final int missed;
  final int rejected;
  final int totalDuration;
  final int blocked;
  final int voicemail;

  const CallLogStats({
    required this.total,
    required this.incoming,
    required this.outgoing,
    required this.missed,
    required this.rejected,
    required this.totalDuration,
    required this.blocked,
    required this.voicemail,
  });

  factory CallLogStats.empty() {
    return const CallLogStats(
      total: 0,
      incoming: 0,
      outgoing: 0,
      missed: 0,
      rejected: 0,
      totalDuration: 0,
      blocked: 0,
      voicemail: 0,
    );
  }

  /// Format total duration as human readable string
  String get formattedTotalDuration {
    if (totalDuration == 0) return '0s';

    final hours = totalDuration ~/ 3600;
    final minutes = (totalDuration % 3600) ~/ 60;
    final seconds = totalDuration % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m ${seconds}s';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    }
    return '${seconds}s';
  }
}


/// Extension for CallType display
extension CallTypeExtension on CallType {
  String get displayName {
    switch (this) {
      case CallType.incoming:
        return 'Incoming';
      case CallType.outgoing:
        return 'Outgoing';
      case CallType.missed:
        return 'Missed';
      case CallType.rejected: 
        return 'Rejected';
      case CallType.unknown:
        return 'Unknown';
      case CallType.voiceMail:
        return 'Voice Mail';
      case CallType.blocked:
        return 'Blocked';
      case CallType.answeredExternally:
        return 'Answered Externally';
      case CallType.wifiIncoming:
        return 'WiFi Incoming';
      case CallType.wifiOutgoing:
        return 'WiFi Outgoing';
    }
  }

  /// Get icon for call type
  IconData get icon {
    switch (this) {
      case CallType.incoming:   
        return Icons.call_received;
      case CallType.outgoing:
        return Icons.call_made;
      case CallType.missed:
        return Icons.call_missed;
      case CallType.rejected:
        return Icons.call;
      case CallType.unknown:
        return Icons.device_unknown;
      case CallType.voiceMail:
        return Icons.voicemail;   
      case CallType.blocked:
        return Icons.block;
      case CallType.answeredExternally:
        return Icons.device_unknown;
      case CallType.wifiIncoming:
        return Icons.wifi_calling;
      case CallType.wifiOutgoing:
        return Icons.wifi_calling;
    }
  }
}