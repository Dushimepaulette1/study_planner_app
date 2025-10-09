import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:study_planner_app/models/task.dart';
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
  late Future<List<Task>> _allTasks;

  @override
  void initState() {
    super.initState();
    _allTasks = _storageService.loadTasks();
  }

  void _refreshTasks() {
    setState(() {
      _allTasks = _storageService.loadTasks();
    });
  }

  List<DateTime> _getDaysInMonth(DateTime month) {
    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0);
    final days = <DateTime>[];

    // Add days from previous month to fill the first week
    final firstWeekday = firstDay.weekday;
    for (int i = firstWeekday - 1; i > 0; i--) {
      days.add(firstDay.subtract(Duration(days: i)));
    }

    // Add days of current month
    for (int i = 0; i < lastDay.day; i++) {
      days.add(DateTime(month.year, month.month, i + 1));
    }

    // Add days from next month to fill the last week
    final totalCells = 42; // 6 weeks
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

  bool _hasTasksOnDate(DateTime date, List<Task> tasks) {
    return tasks.any((task) => _isSameDay(task.dueDate, date));
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
      body: Column(
        children: [
          // Calendar Section
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
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
                        onPressed: () {
                          setState(() {
                            _currentMonth = DateTime(
                              _currentMonth.year,
                              _currentMonth.month - 1,
                            );
                          });
                        },
                        icon: const Icon(Icons.chevron_left),
                      ),
                      Text(
                        DateFormat('MMMM yyyy').format(_currentMonth),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryBackground,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _currentMonth = DateTime(
                              _currentMonth.year,
                              _currentMonth.month + 1,
                            );
                          });
                        },
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
                FutureBuilder<List<Task>>(
                  future: _allTasks,
                  builder: (context, snapshot) {
                    final tasks = snapshot.data ?? [];
                    final days = _getDaysInMonth(_currentMonth);

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 7,
                          ),
                      itemCount: days.length,
                      itemBuilder: (context, index) {
                        final date = days[index];
                        final hasTasks = _hasTasksOnDate(date, tasks);
                        final isCurrentMonth =
                            date.month == _currentMonth.month;
                        final isSelected = _isSameDay(date, _selectedDate);

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedDate = date;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.accentColor
                                  : Colors.transparent,
                              shape: BoxShape.circle,
                              border: hasTasks && !isSelected
                                  ? Border.all(
                                      color: AppColors.primaryBackground,
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
                                            : AppColors.primaryBackground)
                                      : Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          // Tasks Section
          Expanded(
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tasks for ${DateFormat('MMM dd, yyyy').format(_selectedDate)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryBackground,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: FutureBuilder<List<Task>>(
                        future: _allTasks,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          final tasks = snapshot.data ?? [];
                          final dateTasks = tasks
                              .where(
                                (task) =>
                                    _isSameDay(task.dueDate, _selectedDate),
                              )
                              .toList();

                          if (dateTasks.isEmpty) {
                            return const Center(
                              child: Text(
                                'No tasks for this date',
                                style: TextStyle(color: Colors.grey),
                              ),
                            );
                          }

                          return ListView.builder(
                            itemCount: dateTasks.length,
                            itemBuilder: (context, index) {
                              final task = dateTasks[index];
                              return Card(
                                margin: const EdgeInsets.only(bottom: 8),
                                child: ListTile(
                                  title: Text(task.title),
                                  subtitle: Text(
                                    DateFormat('HH:mm').format(task.dueDate),
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      _storageService.deleteTask(task.id).then((
                                        _,
                                      ) {
                                        _refreshTasks();
                                      });
                                    },
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
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
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.primaryBackground,
          ),
        ),
      ),
    );
  }
}
