# Flutter Todo List App

A simple, elegant, and feature-rich Todo List application built with Flutter. This app helps you manage your daily tasks with ease and efficiency.

## Features

- ✅ Create, view, and delete tasks
- 🔄 Update existing tasks
- 🗑️ Clear all tasks with a single tap
- 📤 Export your tasks to a JSON file
- 📥 Import tasks from a JSON file
- 💾 Persistent storage using SQLite database with optimized queries
- 🎨 Clean and intuitive Material Design UI
- 🛠️ Well-structured code with singleton pattern for database operations
- 🔒 Memory-efficient task management with proper resource disposal

## Screenshots

(Add screenshots of your app here)

## Technologies Used

- **Flutter** - UI framework (version 3.2.0+)
- **Provider** - State management
- **SQLite (sqflite)** - Local database storage
- **Path Provider** - File system access
- **File Picker** - Import/export functionality
- **Permission Handler** - Manage storage permissions

## Architecture

This application follows a well-structured architecture:

- **Models Layer**: Clean data models with conversion methods
- **Services Layer**: Singleton database helper with optimized queries
- **Provider Layer**: State management with proper lifecycle handling
- **UI Layer**: Separated screens and reusable widgets

## Getting Started

### Prerequisites

- Flutter SDK (version 3.2.0 or higher)
- Dart SDK (version 3.2.0 or higher)
- Android Studio / VS Code with Flutter extensions

### Installation

1. Clone this repository:
   ```
   git clone https://github.com/yourusername/flutter_todo_list_app.git
   ```

2. Navigate to the project directory:
   ```
   cd flutter_todo_list_app
   ```

3. Install dependencies:
   ```
   flutter pub get
   ```

4. Run the app:
   ```
   flutter run
   ```

## Usage

- **Add a task**: Tap the floating action button and enter your task
- **Update a task**: Tap on an existing task to edit its details
- **Delete a task**: Swipe the task to delete it
- **Clear all tasks**: Tap the broom icon in the app bar
- **Export tasks**: Tap the download icon to save your tasks as a JSON file
- **Import tasks**: Tap the upload icon to load tasks from a JSON file

## Project Structure

```
lib/
├── main.dart           # Entry point of the application
├── models/             # Data models
│   └── task.dart       # Task model with database mapping
├── providers/          # State management
│   └── todo_model.dart # Manages task state and db operations
├── screens/            # UI screens
│   └── todo_list_page.dart
├── services/           # Business logic and services
│   ├── file_service.dart
│   └── database/
│       └── database_helper.dart  # SQLite database operations
└── widgets/            # Reusable UI components
    └── add_task_dialog.dart
```

## Code Quality Features

- **Singleton Pattern**: Efficient database management
- **Proper Encapsulation**: Private methods and variables
- **Resource Management**: Database connections properly closed
- **Documentation**: Well-documented code with descriptive comments
- **Null Safety**: Proper handling of nullable types
- **Clean Architecture**: Separation of concerns between layers
- **Efficient Queries**: Optimized database operations

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgements

- Flutter team for the amazing framework
- All the package authors that made this project possible
- Last updated: March 2025
