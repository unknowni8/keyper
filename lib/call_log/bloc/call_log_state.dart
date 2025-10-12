part of 'call_log_bloc.dart';

// States
abstract class CallLogState extends Equatable {
  const CallLogState();
  @override
  List<Object?> get props => [];
}

class CallLogInitial extends CallLogState {
  const CallLogInitial();
}

class CallLogPermissionDenied extends CallLogState {
  const CallLogPermissionDenied();
}

class CallLogLoading extends CallLogState {
  const CallLogLoading();
}

class CallLogLoadingMore extends CallLogState {   
  const CallLogLoadingMore(this.currentLogs);
  final List<CallLog> currentLogs;
  
  @override
  List<Object?> get props => [currentLogs];
}

class CallLogLoaded extends CallLogState {

  const CallLogLoaded({
    required this.callLogs,
    this.hasMore = true,
    this.searchQuery,
    this.filterType,
    this.isRefreshing = false,
  });
  final List<CallLog> callLogs;
  final bool hasMore;
  final String? searchQuery;
  final CallType? filterType;
  final bool isRefreshing;

  @override
  List<Object?> get props => [
        callLogs,
        hasMore,
        searchQuery,
        filterType,
        isRefreshing,
      ];

  CallLogLoaded copyWith({
    List<CallLog>? callLogs,
    bool? hasMore,
    String? searchQuery,
    CallType? filterType,
    bool? isRefreshing,
    bool clearSearchQuery = false,
    bool clearFilterType = false,
  }) {
    return CallLogLoaded(
      callLogs: callLogs ?? this.callLogs,
      hasMore: hasMore ?? this.hasMore,
      searchQuery: clearSearchQuery ? null : (searchQuery ?? this.searchQuery),
      filterType: clearFilterType ? null : (filterType ?? this.filterType),
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }
}

class CallLogError extends CallLogState {
  const CallLogError(this.message);
  final String message;
  
  @override
  List<Object?> get props => [message];
}
