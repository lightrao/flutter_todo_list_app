# Flutter Todo List App

A simple, elegant, and feature-rich Todo List application built with Flutter. This app helps you manage your daily tasks with ease.

## Features

- ✅ Create, view, and delete tasks
- 🗑️ Clear all tasks with a single tap
- 📤 Export your tasks to a JSON file
- 📥 Import tasks from a JSON file
- 💾 Persistent storage using SQLite database
- 🎨 Clean and intuitive Material Design UI

## Screenshots

(Add screenshots of your app here)

## Technologies Used

- Flutter - UI framework
- Provider - State management
- SQLite (sqflite) - Local database storage
- Path Provider - File system access
- File Picker - Import/export functionality
- Permission Handler - Manage storage permissions

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
- **Delete a task**: Swipe the task to delete it
- **Clear all tasks**: Tap the broom icon in the app bar
- **Export tasks**: Tap the download icon to save your tasks as a JSON file
- **Import tasks**: Tap the upload icon to load tasks from a JSON file

## Project Structure

- `lib/models/` - Data models
- `lib/providers/` - State management
- `lib/screens/` - UI screens
- `lib/services/` - Database and file operations
- `lib/widgets/` - Reusable UI components

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgements

- Flutter team for the amazing framework
- All the package authors that made this project possible
