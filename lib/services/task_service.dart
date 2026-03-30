import '../models/focus_task.dart';

/// Manages focus tasks that, when completed, grant a temporary unlock.
class TaskService {
  final List<FocusTask> _tasks = [];

  List<FocusTask> get tasks => List.unmodifiable(_tasks);

  FocusTask? get activeTask =>
      _tasks.where((t) => t.status == TaskStatus.inProgress).firstOrNull;

  void startTask(String taskId) {
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index != -1) {
      _tasks[index].status = TaskStatus.inProgress;
    }
  }

  /// Call when the user successfully finishes a challenge.
  /// Returns the task if it was in progress, null otherwise.
  FocusTask? completeTask(String taskId) {
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index != -1 && _tasks[index].status == TaskStatus.inProgress) {
      _tasks[index].status = TaskStatus.completed;
      return _tasks[index];
    }
    return null;
  }

  void failTask(String taskId) {
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index != -1) {
      _tasks[index].status = TaskStatus.failed;
    }
  }

  void addTask(FocusTask task) => _tasks.add(task);
}
