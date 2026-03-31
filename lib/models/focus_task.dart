import 'app_tier.dart';

/// Task type determines which challenge screen is shown.
enum TaskType { focus, breathing, quiz, custom }

enum TaskStatus { pending, inProgress, completed, failed }

class FocusTask {
  final String id;
  final String title;
  final String description;
  final TaskType type;
  TaskStatus status;
  final Duration? duration;
  final AppTier tier;

  FocusTask({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    this.status = TaskStatus.pending,
    this.duration,
    this.tier = AppTier.normal,
  });
}
