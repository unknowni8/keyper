import 'package:app_logger/app_logger.dart';
import 'package:call_log_repository/call_log_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'call_log_event.dart';
part 'call_log_state.dart';


// BLoC
class CallLogBloc extends Bloc<CallLogEvent, CallLogState> {

  CallLogBloc({required CallLogRepository repository})
      : _repository = repository,
        super(const CallLogInitial()) {
    on<LoadCallLogs>(_onLoadCallLogs);
    on<RefreshCallLogs>(_onRefreshCallLogs);
    on<LoadMoreCallLogs>(_onLoadMoreCallLogs);
    on<SearchCallLogs>(_onSearchCallLogs);
    on<FilterCallLogsByType>(_onFilterCallLogsByType);
    on<RequestPermission>(_onRequestPermission);
  }
  final CallLogRepository _repository;
  static const int _pageSize = 20;

  Future<void> _onLoadCallLogs(
    LoadCallLogs event,
    Emitter<CallLogState> emit,
  ) async {
    try {
      emit(const CallLogLoading());

      // Check permission first
      final hasPermission = await _repository.hasPermission();
      if (!hasPermission) {
        emit(const CallLogPermissionDenied());
        return;
      }

      final callLogs = await _repository.fetchCallLogs();
      final hasMore = callLogs.length == _pageSize;

      emit(CallLogLoaded(
        callLogs: callLogs,
        hasMore: hasMore,
      ));

    } on Exception catch (e) {
      AppLogger.error(
        'Error loading call logs',
        tag: 'CALL_LOGS_BLOC',
        error: e,
      );
      emit(CallLogError('Failed to load call logs: $e'));
    }
  }

  Future<void> _onRefreshCallLogs(
    RefreshCallLogs event,
    Emitter<CallLogState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is CallLogLoaded) {
        emit(currentState.copyWith(isRefreshing: true));
      }

      final callLogs = await _repository.fetchCallLogs();
      final hasMore = callLogs.length == _pageSize;

      emit(CallLogLoaded(
        callLogs: callLogs,
        hasMore: hasMore,
      ));

    } on Exception catch (e) {
      AppLogger.error(
        'Error refreshing call logs',
        tag: 'CALL_LOGS_BLOC',
        error: e,
      );
      emit(CallLogError('Failed to refresh call logs: $e'));
    }
  }

  Future<void> _onLoadMoreCallLogs(
    LoadMoreCallLogs event,
    Emitter<CallLogState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is! CallLogLoaded || !currentState.hasMore) {
        return;
      }

      emit(CallLogLoadingMore(currentState.callLogs));


      List<CallLog> newLogs;
      if (currentState.searchQuery != null) {
        (currentState.callLogs.length / _pageSize).floor();
        newLogs = await _repository.searchCallLogs(
          query: currentState.searchQuery!,
        );
      } else if (currentState.filterType != null) {
        newLogs = await _repository.fetchCallLogsByType(
          callType: currentState.filterType!,
        );
      } else {
        newLogs = await _repository.fetchCallLogs();
      }

      final allLogs = [...currentState.callLogs, ...newLogs];
      final hasMore = newLogs.length == _pageSize;

      emit(currentState.copyWith(
        callLogs: allLogs,
        hasMore: hasMore,
      ));

    } on Exception catch (e) {
      AppLogger.error(
        'Error loading more call logs',
        tag: 'CALL_LOGS_BLOC',
        error: e,
      );
      emit(CallLogError('Failed to load more call logs: $e'));
    }
  }

  Future<void> _onSearchCallLogs(
    SearchCallLogs event,
    Emitter<CallLogState> emit,
  ) async {
    try {
      emit(const CallLogLoading());


      final callLogs = await _repository.searchCallLogs(
        query: event.query,
      );
      final hasMore = callLogs.length == _pageSize;

      emit(CallLogLoaded(
        callLogs: callLogs,
        hasMore: hasMore,
        searchQuery: event.query,
      ));

    } on Exception catch (e) {
      AppLogger.error(
        'Error searching call logs',
        tag: 'CALL_LOGS_BLOC',
        error: e,
      );
      emit(CallLogError('Failed to search call logs: $e'));
    }
  }

  Future<void> _onFilterCallLogsByType(
    FilterCallLogsByType event,
    Emitter<CallLogState> emit,
  ) async {
    try {
      emit(const CallLogLoading());


      List<CallLog> callLogs;
      if (event.callType == null) {
        // Clear filter - load all
        callLogs = await _repository.fetchCallLogs();
      } else {
        callLogs = await _repository.fetchCallLogsByType(
          callType: event.callType!,
        );
      }

      final hasMore = callLogs.length == _pageSize;

      emit(CallLogLoaded(
        callLogs: callLogs,
        hasMore: hasMore,
        filterType: event.callType,
      ));

    } on Exception catch (e) {
      AppLogger.error(
        'Error filtering call logs',
        tag: 'CALL_LOGS_BLOC',
        error: e,
      );
      emit(CallLogError('Failed to filter call logs: $e'));
    }
  }

  Future<void> _onRequestPermission(
    RequestPermission event,
    Emitter<CallLogState> emit,
  ) async {
    try {

      final granted = await _repository.requestPermission();
      if (granted) {
        add(const LoadCallLogs());
      } else {
        emit(const CallLogPermissionDenied());
      }
    } on Exception catch (e) {
      AppLogger.error(
        'Error requesting permission',
        tag: 'CALL_LOGS_BLOC',
        error: e,
      );
      emit(CallLogError('Failed to request permission: $e'));
    }
  }
}
