import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:study_planner_app/models/task.dart';
import 'package:study_planner_app/services/storage_service.dart';
import 'package:study_planner_app/utils/colors.dart';

class TodayScreen extends StatefulWidget {
  const TodayScreen({super.key});

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  final StorageService _storageService = StorageService();
  late Future<List<Task>> _todayTasks;

  @override
  void initState() {
    super.initState();
    _loadTodayTasks();
  }

  void _loadTodayTasks() {
    setState(() {
      _todayTasks = _storageService.loadTasks().then((tasks) {
        final now = DateTime.now();
        return tasks.where((task) {
          return task.dueDate.year == now.year &&
              task.dueDate.month == now.month &&
              task.dueDate.day == now.day;
        }).toList();
      });
    });
  }

  void _toggleTaskCompletion(Task task) {
    _storageService.toggleTaskCompletion(task.id).then((_) {
      _loadTodayTasks(); // Reload tasks to reflect the change
    });
  }

  void _deleteTask(String taskId) {
    _storageService.deleteTask(taskId).then((_) {
      _loadTodayTasks(); // Reload tasks after deletion
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Today',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : null,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: FutureBuilder<List<Task>>(
                future: _todayTasks,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error, color: Colors.red, size: 50),
                          const SizedBox(height: 16),
                          Text(
                            'Error loading tasks: ${snapshot.error}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }

                  final tasks = snapshot.data ?? [];

                  if (tasks.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            size: 60,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No tasks for today!',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Add a new task to get started',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return Dismissible(
                        key: Key(task.id),
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          _deleteTask(task.id);
                        },
                        child: Card(
                          color: Theme.of(context).cardColor,
                          margin: const EdgeInsets.only(bottom: 8),
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              // Remove splash effect
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                            ),
                            child: CheckboxListTile(
                              value: task.isCompleted,
                              onChanged: (bool? value) {
                                _toggleTaskCompletion(task);
                              },
                              // Customize checkbox appearance
                              activeColor: Colors.green,
                              checkColor: Colors.white,
                              title: Text(
                                task.title,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  decoration: task.isCompleted
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                  color: task.isCompleted
                                      ? Colors.grey
                                      : Theme.of(context).brightness ==
                                            Brightness.dark
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (task.description != null &&
                                      task.description!.isNotEmpty)
                                    Text(
                                      task.description!,
                                      style: TextStyle(
                                        decoration: task.isCompleted
                                            ? TextDecoration.lineThrough
                                            : TextDecoration.none,
                                        color: task.isCompleted
                                            ? Colors.grey
                                            : Theme.of(context).brightness ==
                                                  Brightness.dark
                                            ? Colors.white70
                                            : Colors.black54,
                                      ),
                                    ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.access_time,
                                        size: 14,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        DateFormat(
                                          'HH:mm',
                                        ).format(task.dueDate),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: task.isCompleted
                                              ? Colors.grey
                                              : Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              secondary: Icon(
                                task.isCompleted
                                    ? Icons.check_circle
                                    : Icons.fiber_manual_record,
                                color: task.isCompleted
                                    ? Colors.green
                                    : Theme.of(context).brightness ==
                                          Brightness.dark
                                    ? AppColors.darkPrimary
                                    : AppColors.lightPrimary,
                                size: 24,
                              ),
                              controlAffinity: ListTileControlAffinity.leading,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
