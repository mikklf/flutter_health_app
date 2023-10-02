part of 'sync_cubit.dart';

final class SyncState extends Equatable {

  final DateTime lastSyncTime;
  final bool isSyncing;

  const SyncState({
    required this.lastSyncTime,
    this.isSyncing = false});

  @override
  List<Object> get props => [lastSyncTime, isSyncing];

  /// Returns a copy of [SyncState] with the given fields replaced with the new values.
  SyncState copyWith({
    DateTime? lastSyncTime,
    bool? isSyncing,
  }) {
    return SyncState(
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
      isSyncing: isSyncing ?? this.isSyncing,
    );
  }
  

  
}
