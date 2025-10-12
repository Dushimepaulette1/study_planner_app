# Study Planner App

A feature-rich Flutter application designed to help students manage their study tasks, deadlines, and reminders.
<img width="466" height="940" alt="Screenshot 2025-10-12 213240" src="https://github.com/user-attachments/assets/4f21de8d-f692-418c-8ea0-9fdc99570783" />

## Features

- **Task Management**: Create, view, edit, and delete study tasks
- **Task Prioritization**: Organize tasks by due date and completion status
- **Calendar View**: Visualize tasks in a calendar format
- **Reminders**: Set reminders for upcoming tasks
- **Dark/Light Theme**: Toggle between dark and light mode for comfortable viewing
- **Local Storage**: All data is stored locally on the device

## Screenshots

### Today Screen

<img width="350" alt="Today Screen" src="https://github.com/user-attachments/assets/10c33fe4-d5d0-4124-a647-5f78e040fa65" />

### Calendar View

<img width="350" alt="Calendar View" src="https://github.com/user-attachments/assets/a6b5799c-e450-45d8-9816-e2efcc7a2250" />

### New Task

<img width="350" alt="New Task" src="https://github.com/user-attachments/assets/f5d1d5fc-61f4-4093-92fb-f00dea9e54e1" />

<img width="350" alt="Task Details" src="https://github.com/user-attachments/assets/c914e5fd-121e-4a1a-83da-7f34bd8464c6" />

### Settings

<img width="350" alt="Settings" src="https://github.com/user-attachments/assets/9d30a354-0fb5-4d54-92d2-81f4a0b89d3c" />

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
   git clone https://github.com/Dushimepaulette1/study_planner_app.git
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
