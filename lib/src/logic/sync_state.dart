part of 'sync_cubit.dart';

final class SyncState extends Equatable {

  final bool isSyncing;

  const SyncState({this.isSyncing = false});

  @override
  List<Object> get props => [isSyncing];

  /// Returns a copy of [SyncState] with the given fields replaced with the new values.
  SyncState copyWith({
    bool? isSyncing,
  }) {
    return SyncState(
      isSyncing: isSyncing ?? this.isSyncing,
    );
  }
  

  
}
