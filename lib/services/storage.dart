import 'dart:convert'; // ADD THIS LINE
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

class StorageService {
  Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = tasks.map((task) => task.toJson()).toList();
    await prefs.setString('tasks', json.encode(tasksJson));
  }

  Future<List<Task>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJsonString = prefs.getString('tasks');

    if (tasksJsonString == null) {
      return [];
    }

    final List<dynamic> tasksJson = json.decode(tasksJsonString);
    return tasksJson.map((json) => Task.fromJson(json)).toList();
  }

  Future<void> saveTask(Task task) async {
    final tasks = await loadTasks();
    tasks.add(task);
    await saveTasks(tasks);
  }

  // Remove the old unimplemented methods or keep them if you want
}
