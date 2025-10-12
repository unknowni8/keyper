import 'package:call_log_repository/call_log_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keyper/call_log/bloc/call_log_bloc.dart';
import 'package:permission_client/permission_client.dart';

class CallLogPage extends StatelessWidget {
  const CallLogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CallLogBloc(
        repository: CallLogRepository(
          permissionClient: const PermissionClient(),
        ),
      )..add(const LoadCallLogs()),
      child: const CallLogsView(),
    );
  }
}

class CallLogsView extends StatefulWidget {
  const CallLogsView({super.key});

  @override
  State<CallLogsView> createState() => _CallLogsViewState();
}

class _CallLogsViewState extends State<CallLogsView> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  CallType? _selectedFilter;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<CallLogBloc>().add(const LoadMoreCallLogs());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _onSearchChanged(String query) {
    if (query.isEmpty) {
      context.read<CallLogBloc>().add(const LoadCallLogs());
    } else {
      context.read<CallLogBloc>().add(SearchCallLogs(query));
    }
  }

  void _onFilterChanged(CallType? callType) {
    setState(() {
      _selectedFilter = callType;
    });
    context.read<CallLogBloc>().add(FilterCallLogsByType(callType));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Call Logs'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 1,
      ),
      body: Column(
        children: [
          _buildSearchBar(context),
          _buildFilterChips(context),
          const SizedBox(height: 8),
          Expanded(
            child: BlocBuilder<CallLogBloc, CallLogState>(
              builder: (context, state) {
                switch (state.runtimeType) {
                  case CallLogPermissionDenied:
                    return _buildPermissionDenied(context);
                  case CallLogError:
                    return _buildError(context, (state as CallLogError).message);
                  case CallLogLoaded: 
                    return _buildCallLogsList(context, state as CallLogLoaded);
                  case CallLogLoadingMore:
                    final loadingMoreState = state as CallLogLoadingMore;
                    return _buildCallLogsListWithLoading(context, loadingMoreState.currentLogs);
                  default:
                    return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: _searchController,
        onChanged: _onSearchChanged,
        decoration: InputDecoration(
          hintText: 'Search call logs...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _onSearchChanged('');
                  },
                )
              : null,
          filled: true,
          fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 2,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildFilterChips(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filter by type',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip(
                  context,
                  label: 'All',
                  isSelected: _selectedFilter == null,
                  onSelected: () => _onFilterChanged(null),
                  icon: Icons.all_inclusive,
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  context,
                  label: 'Incoming',
                  isSelected: _selectedFilter == CallType.incoming,
                  onSelected: () => _onFilterChanged(CallType.incoming),
                  icon: Icons.call_received,
                  color: Colors.green,
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  context,
                  label: 'Outgoing',
                  isSelected: _selectedFilter == CallType.outgoing,
                  onSelected: () => _onFilterChanged(CallType.outgoing),
                  icon: Icons.call_made,
                  color: Colors.blue,
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  context,
                  label: 'Missed',
                  isSelected: _selectedFilter == CallType.missed,
                  onSelected: () => _onFilterChanged(CallType.missed),
                  icon: Icons.call_received,
                  color: Colors.red,
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  context,
                  label: 'Rejected',
                  isSelected: _selectedFilter == CallType.rejected,
                  onSelected: () => _onFilterChanged(CallType.rejected),
                  icon: Icons.call_end,
                  color: Colors.orange,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    BuildContext context, {
    required String label,
    required bool isSelected,
    required VoidCallback onSelected,
    required IconData icon,
    Color? color,
  }) {
    final chipColor = color ?? Theme.of(context).colorScheme.primary;
    
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: isSelected 
                ? Colors.white 
                : chipColor,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: isSelected 
                  ? Colors.white 
                  : chipColor,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
      selected: isSelected,
      onSelected: (_) => onSelected(),
      backgroundColor: chipColor.withValues(alpha: 0.1),
      selectedColor: chipColor,
      checkmarkColor: Colors.white,
      elevation: isSelected ? 4 : 0,
      shadowColor: chipColor.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? chipColor : chipColor.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }
  Widget _buildPermissionDenied(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.phone_disabled,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Permission Required',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'This app needs permission to access your call logs to display them.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                context.read<CallLogBloc>().add(const RequestPermission());
              },
              child: const Text('Grant Permission'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Error',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                context.read<CallLogBloc>().add(const LoadCallLogs());
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCallLogsList(BuildContext context, CallLogLoaded state) {
    if (state.callLogs.isEmpty) {
      return _buildEmptyState(context);
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<CallLogBloc>().add(const RefreshCallLogs());
      },
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: state.callLogs.length + (state.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= state.callLogs.length) {
            return _buildPaginationLoadingIndicator(context);
          }

          final callLog = state.callLogs[index];
          return _buildCallLogItem(context, callLog);
        },
      ),
    );
  }

  Widget _buildCallLogsListWithLoading(BuildContext context, List<CallLog> callLogs) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: callLogs.length + 1,
      itemBuilder: (context, index) {
        if (index >= callLogs.length) {
          return _buildPaginationLoadingIndicator(context, isLoading: true);
        }

        final callLog = callLogs[index];
        return _buildCallLogItem(context, callLog);
      },
    );
  }

  Widget _buildPaginationLoadingIndicator(BuildContext context, {bool isLoading = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isLoading) ...[
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(height: 12),
            Text(
              'Loading more call logs...',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ] else ...[
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(height: 8),
            Text(
              'Loading...',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.phone_callback,
                size: 48,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Call Logs',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'No call logs found matching your criteria.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCallLogItem(BuildContext context, CallLog callLog) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          onTap: () => _showCallLogDetails(context, callLog),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Call Type Avatar
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _getCallTypeColor(context, callLog.callType).withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _getCallTypeColor(context, callLog.callType).withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      callLog.callType.icon,
                      size: 24,
                      color: _getCallTypeColor(context, callLog.callType),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                
                // Call Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        callLog.displayName,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      if (callLog.number != null && callLog.number != callLog.name) ...[
                        Text(
                          callLog.number!,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                      ],
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: _getCallTypeColor(context, callLog.callType).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              callLog.callType.displayName,
                              style: TextStyle(
                                color: _getCallTypeColor(context, callLog.callType),
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.access_time,
                            size: 14,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            callLog.formattedDuration,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Time and Arrow
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      callLog.formattedTime,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Icon(
                      Icons.chevron_right,
                      color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                      size: 20,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getCallTypeColor(BuildContext context, CallType callType) {
    switch (callType) {
      case CallType.incoming:
        return Colors.green;
      case CallType.outgoing:
        return Colors.blue;
      case CallType.missed:
        return Colors.red;
      case CallType.rejected:
        return Colors.orange;
      case CallType.unknown:
        return Theme.of(context).colorScheme.outline;
      case CallType.voiceMail:
        return Colors.purple;
      case CallType.blocked:
        return Colors.red;   
      case CallType.answeredExternally:     
        return Colors.yellow;
      case CallType.wifiIncoming:
        return Colors.lightBlue;
      case CallType.wifiOutgoing:
        return Colors.lightBlue;
    }
  }

  void _showCallLogDetails(BuildContext context, CallLog callLog) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  callLog.callType.icon,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    callLog.displayName,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (callLog.number != null) ...[
              _buildDetailRow('Number', callLog.number!),
              const SizedBox(height: 8),
            ],
            _buildDetailRow('Type', callLog.callType.displayName),
            const SizedBox(height: 8),
            _buildDetailRow('Duration', callLog.formattedDuration),
            const SizedBox(height: 8),
            if (callLog.timestamp != null) ...[
              _buildDetailRow('Time', callLog.timestamp!.toString()),
              const SizedBox(height: 8),
            ],
            if (callLog.cachedNumberType != null) ...[
              _buildDetailRow('Number Type', callLog.cachedNumberType!),
              const SizedBox(height: 8),
            ],
            if (callLog.cachedNumberLabel != null) ...[
              _buildDetailRow('Label', callLog.cachedNumberLabel!),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            '$label:',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(
          child: Text(value),
        ),
      ],
    );
  }
}