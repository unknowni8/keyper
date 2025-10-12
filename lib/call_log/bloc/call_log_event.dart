part of 'call_log_bloc.dart';

// Events
sealed class CallLogEvent extends Equatable {
  const CallLogEvent();
  @override
  List<Object?> get props => [];
}

class LoadCallLogs extends CallLogEvent {
  const LoadCallLogs();
}

class RefreshCallLogs extends CallLogEvent {
  const RefreshCallLogs();
}

class LoadMoreCallLogs extends CallLogEvent {
  const LoadMoreCallLogs();
}

class SearchCallLogs extends CallLogEvent {
  const SearchCallLogs(this.query);
  final String query;
  
  @override
  List<Object?> get props => [query];
}

class FilterCallLogsByType extends CallLogEvent {
  const FilterCallLogsByType(this.callType);
  final CallType? callType;
  
  @override
  List<Object?> get props => [callType];
}

class RequestPermission extends CallLogEvent {
  const RequestPermission();
}

