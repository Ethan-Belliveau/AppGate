import '../models/app_entry.dart';

/// Manages the list of apps and their blocked/time-limit state.
/// Actual OS-level enforcement will be implemented via platform channels
/// (iOS Screen Time API / Android UsageStats + DevicePolicyManager).
class AppBlockService {
  final List<AppEntry> _apps = [];

  List<AppEntry> get apps => List.unmodifiable(_apps);
  List<AppEntry> get blockedApps => _apps.where((a) => a.isBlocked).toList();

  void setBlocked(String appId, {required bool blocked}) {
    final index = _apps.indexWhere((a) => a.id == appId);
    if (index != -1) {
      _apps[index] = _apps[index].copyWith(isBlocked: blocked);
    }
  }

  void setTimeLimit(String appId, int? minutes) {
    final index = _apps.indexWhere((a) => a.id == appId);
    if (index != -1) {
      _apps[index] = _apps[index].copyWith(timeLimitMinutes: minutes);
    }
  }

  void blockAll() {
    for (int i = 0; i < _apps.length; i++) {
      _apps[i] = _apps[i].copyWith(isBlocked: true);
    }
  }

  void unblockAll() {
    for (int i = 0; i < _apps.length; i++) {
      _apps[i] = _apps[i].copyWith(isBlocked: false);
    }
  }
}
