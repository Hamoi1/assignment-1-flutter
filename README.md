# Task Manager App

A modern, feature-rich Task Manager application built with Flutter, GetX state management, and Google Drive backup integration.

## Features

### Core Functionality
- ✅ **Task Management**: Create, read, update, and delete tasks
- 📝 **Task Properties**: Title, description, category, date, and completion status
- 🔍 **Search & Filter**: Search tasks by title/description and filter by category
- 📊 **Statistics**: View total, completed, and pending task counts
- 💾 **Local Storage**: Persistent storage using GetStorage

### Google Drive Backup
- ☁️ **Cloud Backup**: Upload tasks to Google Drive
- 🔄 **Auto Backup**: Automatically backup when creating new tasks
- 👤 **Google Sign-In**: Secure authentication with Google account
- 📁 **Backup File**: Tasks stored as `tasks_backup.json` in app data folder

### UI/UX
- 🎨 **Beautiful Design**: Modern, clean interface with smooth animations
- 🌓 **Dark/Light Mode**: Toggle between dark and light themes
- 🎯 **Category Colors**: Color-coded categories for easy identification
- 📱 **Responsive**: Works on all screen sizes

## Categories
- Work (Blue)
- Personal (Green)
- Shopping (Orange)
- Health (Red)
- Other (Purple)

## Screens

1. **Splash Screen**: Animated welcome screen
2. **Home Screen**: Task list with search and filters
3. **Add Task Screen**: Create new tasks
4. **Task Details Screen**: View and edit task details
5. **Settings Screen**: Google Drive backup and theme settings

## Dependencies

```yaml
dependencies:
  get: ^4.6.6                    # State management & routing
  get_storage: ^2.1.1            # Local storage
  google_sign_in: ^6.2.1         # Google authentication
  googleapis: ^13.2.0            # Google APIs
  http: ^1.2.1                   # HTTP requests
  google_fonts: ^6.2.1           # Custom fonts
  intl: ^0.19.0                  # Date formatting
  flutter_animate: ^4.5.0        # Animations
```

## Getting Started

### Prerequisites
- Flutter SDK (latest stable version)
- Android Studio / VS Code
- Google Cloud Project with Drive API enabled (for backup feature)

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd assignment
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## Project Structure

```
lib/
├── main.dart                      # App entry point
├── routes.dart                    # Route configuration
├── controllers/
│   ├── task_controller.dart       # Task management logic
│   └── backup_controller.dart     # Google Drive backup logic
├── models/
│   └── task_model.dart           # Task data model
├── theme/
│   ├── app_theme.dart            # Theme definitions
│   └── theme_service.dart        # Theme state management
└── views/
    ├── splash_screen.dart        # Splash screen
    ├── home_screen.dart          # Main task list
    ├── add_task_screen.dart      # Create task form
    ├── task_details_screen.dart  # Task details & editing
    └── settings_screen.dart      # Settings & backup
```

## Usage

### Creating a Task
1. Tap the **"Add Task"** floating action button
2. Fill in task details (title, description, category, date)
3. Tap **"Save Task"**

### Searching Tasks
- Use the search bar at the top of the home screen
- Filter by category using the chips below the search bar

### Google Drive Backup
1. Go to **Settings**
2. Tap **"Sign In"** under Google Drive Backup
3. Sign in with your Google account
4. Tap **"Backup Now"** to manually backup
5. Enable **"Auto Backup"** to backup automatically when creating tasks

### Toggling Theme
- Tap the sun/moon icon in the app bar
- Or use the Dark Mode switch in Settings

## Features in Detail

### Task Controller
- `addTask()`: Add new task
- `updateTask()`: Update existing task
- `deleteTask()`: Delete task
- `toggleTaskCompletion()`: Mark task as complete/incomplete
- `searchTasks()`: Search tasks by keyword
- `filterByCategory()`: Filter by category
- `loadTasks()`: Load from storage
- `saveTasks()`: Save to storage
- `autoBackup()`: Trigger auto backup if enabled

### Backup Controller
- `signInWithGoogle()`: Authenticate with Google
- `signOutGoogle()`: Sign out
- `uploadBackupToDrive()`: Upload tasks to Drive
- `toggleAutoBackup()`: Enable/disable auto backup
- `loadSettings()`: Load backup settings
- `saveSettings()`: Save backup settings

## License

This project is created for educational purposes.

## Author

Task Manager App - Flutter Development Assignment

