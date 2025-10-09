import 'package:flutter/material.dart';
import 'package:study_planner_app/main.dart';
import 'package:intl/intl.dart'; // ADDED: For date formatting
import 'package:study_planner_app/services/storage_services.dart'; // FIXED: Correct import path
import 'package:study_planner_app/models/task.dart'; // ADDED: Import Task model
import 'package:study_planner_app/utils/colors.dart'; // ADDED: Import colors

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedDate = DateTime.now();
  DateTime _currentMonth = DateTime.now();
  final StorageService _storageService =
      StorageService(); // ADDED: StorageService instance

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBackground,
        title: Text(
          "My Study Planner",
          style: TextStyle(
            fontSize: 30.0,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // CALENDAR SECTION - WHITE CONTAINER
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(20.0),
                ), // CHANGED: All corners rounded
              ),
              child: Column(
                children: [
                  // Month Header - CHANGED: Using DateFormat for proper month name
                  Container(
                    padding: EdgeInsets.all(16.0),
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
                          icon: Icon(Icons.chevron_left),
                        ),
                        Text(
                          // CHANGED: Using DateFormat for "July 2025" format
                          DateFormat('MMMM yyyy').format(_currentMonth),
                          style: TextStyle(
                            fontSize: 20.0,
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
                          icon: Icon(Icons.chevron_right),
                        ),
                      ],
                    ),
                  ),

                  // Weekday headers
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      children:
                          ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
                              .map(
                                (day) => Expanded(
                                  child: Text(
                                    day,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryBackground,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                  ),

                  // Calendar days grid
                  Container(
                    padding: EdgeInsets.all(16.0),
                    child: GridView.builder(
                      shrinkWrap:
                          true, // ADDED: So GridView doesn't expand infinitely
                      physics:
                          NeverScrollableScrollPhysics(), // ADDED: Prevent inner scrolling
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7,
                      ),
                      itemCount: 42, // 6 weeks
                      itemBuilder: (context, index) {
                        // Calculate date for each grid cell
                        final firstDayOfMonth = DateTime(
                          _currentMonth.year,
                          _currentMonth.month,
                          1,
                        );
                        final weekDay = firstDayOfMonth.weekday;
                        final day = index - weekDay + 1;

                        final date = DateTime(
                          _currentMonth.year,
                          _currentMonth.month,
                          day,
                        );

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedDate = date;
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.all(2.0),
                            decoration: BoxDecoration(
                              color: _isSameDay(date, _selectedDate)
                                  ? Colors.amber
                                  : Colors.transparent,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                date.day.toString(),
                                style: TextStyle(
                                  color: date.month == _currentMonth.month
                                      ? AppColors.primaryBackground
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
              ), // END of Calendar Section Column
            ), // END of Calendar Section Container
            // ADDED: Space between calendar and tasks sections
            SizedBox(height: 16.0),

            // TASKS SECTION - SEPARATE WHITE CONTAINER
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        // CHANGED: Using DateFormat for better date display
                        "Tasks for ${DateFormat('MMM dd, yyyy').format(_selectedDate)}",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryBackground,
                        ),
                      ),
                      SizedBox(height: 10),
                      // This is where tasks for selected date will go
                      Expanded(
                        child: FutureBuilder<List<Task>>(
                          future: _storageService.loadTasks(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            }

                            final tasks = snapshot.data ?? [];
                            final dateTasks = tasks
                                .where(
                                  (task) =>
                                      _isSameDay(task.dueDate, _selectedDate),
                                )
                                .toList();

                            if (dateTasks.isEmpty) {
                              return Center(
                                child: Text(
                                  "No tasks for this date",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              );
                            }

                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: dateTasks.length,
                              itemBuilder: (context, index) {
                                final task = dateTasks[index];
                                return ListTile(
                                  title: Text(task.title),
                                  subtitle: Text(
                                    DateFormat('hh:mm a').format(task.dueDate),
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
              ), // END of Tasks Section Container
            ), // END of Expanded for Tasks Section
          ],
        ),
      ),
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
