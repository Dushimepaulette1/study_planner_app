import 'package:flutter/material.dart';
import 'package:individual_assignment_1/main.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedDate = DateTime.now();
  DateTime _currentMonth = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.primaryBackground,
      appBar: AppBar(
        backgroundColor: CustomColors.primaryBackground,
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
            // Month Header
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
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
                    "${_currentMonth.month}/${_currentMonth.year}",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: CustomColors.primaryBackground,
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
            // Calendar Grid
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20.0),
                    bottomRight: Radius.circular(20.0),
                  ),
                ),
                child: Column(
                  children: [
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
                                        color: CustomColors.primaryBackground,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                      ),
                    ),
                    // Calendar days grid
                    Expanded(
                      child: GridView.builder(
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
                                        ? CustomColors.primaryBackground
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
                    // Selected date tasks section
                    Container(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Tasks for ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: CustomColors.primaryBackground,
                            ),
                          ),
                          SizedBox(height: 10),
                          // This is where tasks for selected date will go
                          Text(
                            "No tasks for this date",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
