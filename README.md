# Study Planner App

A feature-rich Flutter application designed to help students manage their study tasks, deadlines, and reminders.

## Features

- **Task Management**: Create, view, edit, and delete study tasks
- **Task Prioritization**: Organize tasks by due date and completion status
- **Calendar View**: Visualize tasks in a calendar format
- **Reminders**: Set reminders for upcoming tasks
- **Dark/Light Theme**: Toggle between dark and light mode for comfortable viewing
- **Local Storage**: All data is stored locally on the device

## Screenshots

|                        Today Screen                         |                           Calendar View                           |                             New Task                              |                             Settings                              |
| :---------------------------------------------------------: | :---------------------------------------------------------------: | :---------------------------------------------------------------: | :---------------------------------------------------------------: |
| ![Today](https://via.placeholder.com/200?text=Today+Screen) | ![Calendar](https://via.placeholder.com/200?text=Calendar+Screen) | ![New Task](https://via.placeholder.com/200?text=New+Task+Screen) | ![Settings](https://via.placeholder.com/200?text=Settings+Screen) |

## Architecture

The app is built using the following architecture:

- **Models**: Defines the data structures used throughout the app
- **Screens**: UI components for different app views
- **Services**: Business logic and data handling
- **Utils**: Helper functions and constants

### Key Components

1. **Task Model**: Represents study tasks with properties like title, description, due date, and reminder time
2. **Storage Service**: Handles data persistence using SharedPreferences
3. **Notification Service**: Manages task reminders and notifications
4. **Theme Notifier**: Controls app-wide theme changes

## Installation

1. Ensure you have Flutter installed on your machine
2. Clone the repository:
   ```
   git clone https://github.com/Dushimepaulette1/Individual_Assignment_1.git
   ```
3. Navigate to the project directory:
   ```
   cd study_planner_app
   ```
4. Install dependencies:
   ```
   flutter pub get
   ```
5. Run the app:
   ```
   flutter run
   ```

## Technologies Used

- **Flutter**: Cross-platform UI toolkit
- **Dart**: Programming language
- **SharedPreferences**: Local data storage
- **Material Design**: UI design system

## Project Structure

```
lib/
├── main.dart              # App entry point
├── models/                # Data models
│   └── task.dart          # Task model definition
├── screens/               # UI screens
│   ├── calendar_screen.dart
│   ├── new_task_screen.dart
│   ├── settings_screen.dart
│   └── today_screen.dart
├── services/              # Business logic
│   ├── notification_service.dart
│   └── storage_service.dart
└── utils/                 # Helper utilities
    └── colors.dart        # Color definitions
```

## Usage Guide

### Creating a Task

1. Tap the "+" button in the bottom right corner
2. Enter task details (title, description, due date, and time)
3. Enable reminders if needed
4. Tap "Save Task"

### Managing Tasks

- Mark tasks as complete by tapping the checkbox
- View tasks in calendar format by navigating to the Calendar tab
- Change app settings via the Settings tab

### Theme Switching

Toggle between dark and light mode in the Settings screen.

## Demo Video

A demonstration of the app can be viewed [here](https://example.com/demo-video).

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Flutter team for the amazing framework
- Material Design for the UI components
