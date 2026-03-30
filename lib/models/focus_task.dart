/// A task the user must complete to unlock a blocked app or device.
enum TaskType {
  focus,      // Timed focus / no-distraction window
  breathing,  // Guided breathing exercise
  quiz,       // Answer a question correctly
  custom,     // User-defined challenge
}

enum TaskStatus { pending, inProgress, completed, failed }

class FocusTask {
  final String id;
  final String title;
  final String description;
  final TaskType type;
  TaskStatus status;
  final Duration? duration;

  FocusTask({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    this.status = TaskStatus.pending,
    this.duration,
  });
}
