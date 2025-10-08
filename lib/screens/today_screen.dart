import 'package:flutter/material.dart';

class TodayScreen extends StatelessWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Today")),
      body: Column(
        children: [
          Text("Remind Tasks"),
          Text("Read Chapter"),
          Text("Assignment 1"),
          Text("Review Flashcards"),
          ElevatedButton(onPressed: () => {}, child: Text("New Task")),
        ],
      ),
    );
  }
}
