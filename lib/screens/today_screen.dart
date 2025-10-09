import 'package:flutter/material.dart';
import 'package:individual_assignment_1/main.dart';
import 'package:individual_assignment_1/screens/calendar_screen.dart';

class TodayScreen extends StatelessWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Today",
          style: TextStyle(
            fontSize: 33.0,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 500,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                  bottomLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0),
                ),
              ),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(
                            "Remind Tasks",
                            style: TextStyle(
                              fontSize: 25.0,
                              color: CustomColors.appBarColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text(
                            "Read Chapter 1",
                            style: TextStyle(
                              fontSize: 25.0,
                              color: CustomColors.appBarColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          leading: CircleAvatar(
                            backgroundColor: CustomColors.primaryBackground,
                            radius: 5.0,
                          ),
                        ),
                        ListTile(
                          title: Text(
                            "Assignment 1",
                            style: TextStyle(
                              fontSize: 25.0,
                              color: CustomColors.appBarColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          leading: CircleAvatar(
                            backgroundColor: CustomColors.primaryBackground,
                            radius: 5.0,
                          ),
                        ),
                        ListTile(
                          title: Text(
                            "Review Flashcards",
                            style: TextStyle(
                              fontSize: 25.0,
                              color: CustomColors.appBarColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          leading: CircleAvatar(
                            backgroundColor: CustomColors.primaryBackground,
                            radius: 5.0,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Positioned(
                    left: 16.0,
                    right: 16.0,
                    bottom: 16.0,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.black,
                        minimumSize: Size(double.infinity, 50),
                      ),
                      onPressed: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CalendarScreen(),
                          ),
                        ),
                      },
                      child: Text(
                        "New Task",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
