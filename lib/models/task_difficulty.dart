/// Describes how demanding an unlock challenge should be,
/// derived from the user's restriction settings.
enum TaskDifficulty { light, moderate, hard }

/// The context from which an unlock is being requested.
/// Used by [ChallengeSelector] to pick an appropriately weighted challenge.
class RestrictionContext {
  /// Total daily time the app is allowed (minutes).
  final int timeLimitMinutes;

  /// How long the user must wait / how infrequent unlocks are (minutes).
  /// Use 1440 (24 h) for a "daily" break.
  final int breakDurationMinutes;

  const RestrictionContext({
    required this.timeLimitMinutes,
    required this.breakDurationMinutes,
  });

  /// Score = timeLimitHours × breakHours.
  /// Examples:
  ///   1 h limit × 0.5 h break  =  0.5  → light
  ///   2 h limit × 1 h break    =  2.0  → moderate
  ///   4 h limit × 8 h break    = 32.0  → hard
  double get _score =>
      (timeLimitMinutes / 60.0) * (breakDurationMinutes / 60.0);

  TaskDifficulty get difficulty {
    if (_score < 1.0) return TaskDifficulty.light;
    if (_score < 8.0) return TaskDifficulty.moderate;
    return TaskDifficulty.hard;
  }

  /// Human-readable label for the break period.
  String get breakLabel {
    if (breakDurationMinutes >= 1440) return 'daily';
    if (breakDurationMinutes >= 60) {
      final h = breakDurationMinutes ~/ 60;
      return '$h h break';
    }
    return '$breakDurationMinutes min break';
  }
}
