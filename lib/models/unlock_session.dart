/// Records a single unlock event — whether via IAP or completed task.
enum UnlockMethod { iap, task }

class UnlockSession {
  final String id;
  final String appId; // empty string means full-device unlock
  final UnlockMethod method;
  final DateTime unlockedAt;
  final Duration? grantedDuration;

  const UnlockSession({
    required this.id,
    required this.appId,
    required this.method,
    required this.unlockedAt,
    this.grantedDuration,
  });
}
