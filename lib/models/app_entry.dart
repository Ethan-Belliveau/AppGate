/// Represents a device app that can be managed by AppGate.
class AppEntry {
  final String id;
  final String name;
  final String bundleId;
  bool isBlocked;
  int? timeLimitMinutes;

  AppEntry({
    required this.id,
    required this.name,
    required this.bundleId,
    this.isBlocked = false,
    this.timeLimitMinutes,
  });

  AppEntry copyWith({
    bool? isBlocked,
    int? timeLimitMinutes,
  }) {
    return AppEntry(
      id: id,
      name: name,
      bundleId: bundleId,
      isBlocked: isBlocked ?? this.isBlocked,
      timeLimitMinutes: timeLimitMinutes ?? this.timeLimitMinutes,
    );
  }
}
