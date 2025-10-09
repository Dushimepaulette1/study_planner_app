import 'package:flutter/material.dart';
import 'package:study_planner_app/models/task.dart';
import 'package:study_planner_app/services/storage_service.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  final _titleController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  bool _enableNotifications = false;
  String _reminderOption = '1 day before';
  final StorageService _storageService = StorageService();

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _saveTask() {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please enter a title')));
      return;
    }

    // Combine date and time
    final dueDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    // Calculate reminder time based on selection
    DateTime? reminderTime;
    if (_enableNotifications) {
      if (_reminderOption == '1 day before') {
        reminderTime = dueDateTime.subtract(Duration(days: 1));
      } else {
        reminderTime = dueDateTime.subtract(Duration(hours: 1));
      }
    }

    final newTask = Task(
      title: _titleController.text,
      dueDate: dueDateTime,
      reminderTime: reminderTime,
    );

    // Save task (we'll implement this in StorageService next)
    _storageService.saveTask(newTask);

    // Navigate back
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF011339),
      appBar: AppBar(
        backgroundColor: Color(0xFF011339),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'New Task',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // White container for form
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
                      // Title Section
                      Text(
                        'Title',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF011339),
                        ),
                      ),
                      SizedBox(height: 8),
                      TextField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          hintText: 'Enter task title',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12.0,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),

                      // Date Section
                      Text(
                        'Date',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF011339),
                        ),
                      ),
                      SizedBox(height: 8),
                      GestureDetector(
                        onTap: _selectDate,
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: Text(
                            '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),

                      // Time Section
                      Text(
                        'Time',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF011339),
                        ),
                      ),
                      SizedBox(height: 8),
                      GestureDetector(
                        onTap: _selectTime,
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: Text(
                            _selectedTime.format(context),
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),

                      // Notifications Toggle
                      Row(
                        children: [
                          Text(
                            'Notify me',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF011339),
                            ),
                          ),
                          Spacer(),
                          Switch(
                            value: _enableNotifications,
                            onChanged: (value) {
                              setState(() {
                                _enableNotifications = value;
                              });
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 10),

                      // Reminder Options (only show if notifications enabled)
                      if (_enableNotifications) ...[
                        Text(
                          'Remind me',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF011339),
                          ),
                        ),
                        SizedBox(height: 8),
                        Column(
                          children: [
                            RadioListTile<String>(
                              title: Text('Notify me 1 day before'),
                              value: '1 day before',
                              groupValue: _reminderOption,
                              onChanged: (value) {
                                setState(() {
                                  _reminderOption = value!;
                                });
                              },
                            ),
                            RadioListTile<String>(
                              title: Text('Notify me 1 hour before'),
                              value: '1 hour before',
                              groupValue: _reminderOption,
                              onChanged: (value) {
                                setState(() {
                                  _reminderOption = value!;
                                });
                              },
                            ),
                          ],
                        ),
                      ],

                      Spacer(),

                      // Save Button
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          foregroundColor: Colors.black,
                          minimumSize: Size(double.infinity, 50),
                        ),
                        onPressed: _saveTask,
                        child: Text(
                          'Save',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }
}
