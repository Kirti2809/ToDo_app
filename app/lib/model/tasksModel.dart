class Tasks {
  final int userId;
  final int taskId;
  final String task;
  final bool status;

  const Tasks({
    required this.userId,
    required this.task,
    required this.status,
    required this.taskId,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'taskId': taskId,
      'task': task,
      'status' : status,
    };
  }

  @override
  String toString() {
    return 'Tasks{userId: $userId, taskId: $taskId, task: $task, status: $status}';
  }
}