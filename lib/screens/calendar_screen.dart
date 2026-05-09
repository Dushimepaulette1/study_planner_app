import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:study_planner_app/models/task.dart';
import 'package:study_planner_app/services/notification_service.dart';
import 'package:study_planner_app/services/storage_service.dart';
import 'package:study_planner_app/utils/colors.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final StorageService _storageService = StorageService();
  DateTime _selectedDate = DateTime.now();
  DateTime _currentMonth = DateTime.now();
  List<Task> _allTasks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final tasks = await _storageService.loadTasks();
    if (!mounted) return;
    setState(() {
      _allTasks = tasks;
      _isLoading = false;
    });
  }

  List<DateTime> _getDaysInMonth(DateTime month) {
    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0);
    final days = <DateTime>[];

    final firstWeekday = firstDay.weekday;
    for (int i = firstWeekday - 1; i > 0; i--) {
      days.add(firstDay.subtract(Duration(days: i)));
    }

    for (int i = 0; i < lastDay.day; i++) {
      days.add(DateTime(month.year, month.month, i + 1));
    }

    const totalCells = 42;
    while (days.length < totalCells) {
      days.add(days.last.add(const Duration(days: 1)));
    }

    return days;
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  bool _hasTasksOnDate(DateTime date) {
    return _allTasks.any((task) => _isSameDay(task.dueDate, date));
  }

  void _toggleTask(Task task) {
    setState(() {
      final index = _allTasks.indexWhere((t) => t.id == task.id);
      if (index != -1) _allTasks[index] = task.toggleCompletion();
    });
    _storageService.toggleTaskCompletion(task.id);
  }

  void _deleteTask(String taskId) {
    setState(() {
      _allTasks.removeWhere((t) => t.id == taskId);
    });
    _storageService.deleteTask(taskId).then((_) {
      NotificationService().cancelReminder(taskId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Calendar',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Calendar Section
            Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  // Month Header
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () => setState(() {
                            _currentMonth = DateTime(
                              _currentMonth.year,
                              _currentMonth.month - 1,
                            );
                          }),
                          icon: const Icon(Icons.chevron_left),
                        ),
                        Text(
                          DateFormat('MMMM yyyy').format(_currentMonth),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? AppColors.darkText
                                    : AppColors.lightPrimary,
                          ),
                        ),
                        IconButton(
                          onPressed: () => setState(() {
                            _currentMonth = DateTime(
                              _currentMonth.year,
                              _currentMonth.month + 1,
                            );
                          }),
                          icon: const Icon(Icons.chevron_right),
                        ),
                      ],
                    ),
                  ),
                  // Weekday Headers
                  const Row(
                    children: [
                      _WeekdayHeader('Sun'),
                      _WeekdayHeader('Mon'),
                      _WeekdayHeader('Tue'),
                      _WeekdayHeader('Wed'),
                      _WeekdayHeader('Thu'),
                      _WeekdayHeader('Fri'),
                      _WeekdayHeader('Sat'),
                    ],
                  ),
                  // Calendar Grid
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7,
                      ),
                      itemCount: _getDaysInMonth(_currentMonth).length,
                      itemBuilder: (context, index) {
                        final days = _getDaysInMonth(_currentMonth);
                        final date = days[index];
                        final hasTasks = _hasTasksOnDate(date);
                        final isCurrentMonth =
                            date.month == _currentMonth.month;
                        final isSelected = _isSameDay(date, _selectedDate);

                        return GestureDetector(
                          onTap: () => setState(() => _selectedDate = date),
                          child: Container(
                            margin: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.accentColor
                                  : Colors.transparent,
                              shape: BoxShape.circle,
                              border: hasTasks && !isSelected
                                  ? Border.all(
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? AppColors.darkPrimary
                                          : AppColors.lightPrimary,
                                      width: 2,
                                    )
                                  : null,
                            ),
                            child: Center(
                              child: Text(
                                date.day.toString(),
                                style: TextStyle(
                                  color: isCurrentMonth
                                      ? (isSelected
                                          ? Colors.black
                                          : Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? AppColors.darkText
                                              : AppColors.lightPrimary)
                                      : Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Tasks Section
            Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tasks for ${DateFormat('MMM dd, yyyy').format(_selectedDate)}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppColors.darkText
                            : AppColors.lightPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildTaskList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskList() {
    if (_isLoading) {
      return const SizedBox(
        height: 100,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final dateTasks = _allTasks
        .where((task) => _isSameDay(task.dueDate, _selectedDate))
        .toList();

    if (dateTasks.isEmpty) {
      return const SizedBox(
        height: 100,
        child: Center(
          child: Text(
            'No tasks for this date',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 300),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: dateTasks.length,
        itemBuilder: (context, index) {
          final task = dateTasks[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: Checkbox(
                value: task.isCompleted,
                activeColor: Colors.green,
                onChanged: (_) => _toggleTask(task),
              ),
              title: Text(
                task.title,
                style: TextStyle(
                  decoration: task.isCompleted
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                  color: task.isCompleted ? Colors.grey : null,
                ),
              ),
              subtitle: Text(DateFormat('HH:mm').format(task.dueDate)),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _deleteTask(task.id),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _WeekdayHeader extends StatelessWidget {
  final String day;

  const _WeekdayHeader(this.day);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          day,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.darkText
                : AppColors.lightPrimary,
          ),
        ),
      ),
    );
  }
}
