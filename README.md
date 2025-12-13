# 📋 Task Manager App

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![GetX](https://img.shields.io/badge/GetX-8A2BE2?style=for-the-badge)

**A modern, feature-rich Task Manager application built with Flutter and GetX**

</div>

## ✨ Features

### 📝 Task Management
- ✅ **Full CRUD Operations** - Create, Read, Delete tasks
- 📌 **Task Pinning** - Pin important tasks to appear at the top
- 🏷️ **Categories** - Organize tasks by 5 categories (Work, Personal, Shopping, Health, Other)
- 📅 **Due Dates** - Set and track task deadlines
- ✔️ **Completion Status** - Mark tasks as complete/incomplete

### 🔍 Search & Filter
- Search tasks by title and description
- Filter by category
- Automatic sorting (pinned tasks first, then by date)

### 📊 Task Statistics
- Total task count
- Completed tasks count
- Pending tasks count

### 🎨 Design
- 🌓 **Dark/Light Mode** - Toggle themes with one click
- ✨ **Glassmorphism** - Modern glass-like UI design
- 🎯 **Category Colors** - Each category has its unique color
- 💫 **Smooth Animations** - Beautiful transitions throughout

### 💾 Backup & Restore
- Export data to file (.tmbk format)
- Import/restore from file
- Automatic local storage with GetStorage

---

## 🛠️ Technologies

| Technology | Usage |
|---|---|
| **Flutter** | UI Framework |
| **GetX** | State Management & Routing |
| **GetStorage** | Local Data Persistence |
| **Google Fonts** | Noto Sans Arabic Typography |

---

## 📁 Project Structure

```
lib/
├── main.dart                      # App entry point
├── routes.dart                    # Route configuration
│
├── controllers/
│   ├── task_controller.dart       # Task management logic
│   ├── backup_controller.dart     # Backup/restore logic
│
│
├── models/
│   └── task_model.dart            # Task data model
│
├── theme/
│   ├── app_theme.dart             # Light & dark theme definitions
│   └── theme_service.dart         # Theme state management
│
├── utils/
│   └── glassy_snackbar.dart       # Glassmorphism snackbars
│
└── views/
    ├── splash_screen.dart         # Splash screen
    ├── home_screen.dart           # Main screen with tabs
    ├── add_task_screen.dart       # Add task form
    ├── task_details_screen.dart   # Task details & editing
    ├── settings_screen.dart       # Settings & backup
    
```

---

## 🚀 Installation & Setup

### Prerequisites

- **Flutter SDK** version 3.16 or higher
- **Dart SDK** version 3.2 or higher
- **Android Studio** or **VS Code**
- **Git**

### Installation Steps

#### 1️⃣ Clone the Repository
```bash
git clone https://github.com/username/task-manager-app.git
cd task-manager-app
```

#### 2️⃣ Install Dependencies
```bash
flutter pub get
```

#### 3️⃣ Verify Setup
```bash
flutter doctor
```

#### 4️⃣ Run the App

**For Android:**
```bash
flutter run -d android
```

**For Windows:**
```bash
flutter run -d windows
```

**For Web:**
```bash
flutter run -d chrome
```

**For iOS (on macOS):**
```bash
flutter run -d ios
```

#### 5️⃣ Build Release APK
```bash
flutter build apk --release
```
APK file location: `build/app/outputs/flutter-apk/app-release.apk`

---

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter

  # State Management & Routing
  get: ^4.6.6

  # Local Storage
  get_storage: ^2.1.1

  # Google Fonts
  google_fonts: ^6.2.1

  # Date Formatting
  intl: ^0.19.0

  # Animations
  flutter_animate: ^4.5.0

  # Bottom Navigation
  curved_navigation_bar: ^1.0.6

  # Backup & Restore
  file_saver: ^0.2.14
  file_picker: ^8.1.4

```

---

## 🎯 Usage Guide

### Adding a Task
1. Tap the **"+"** tab at the bottom
2. Enter a title (required)
3. Enter a description (optional)
4. Select a category
5. Pick a date
6. Tap **"Add Task"**

### Pinning a Task
1. Tap the 📌 icon on any task card
2. Pinned tasks appear at the top of the list
3. Tap again to unpin

### Changing Theme
- Tap the ☀️/🌙 icon in the app bar

### Backup & Restore
1. Go to **Settings** (left tab)
2. Tap **"Export Data"** to backup
3. A `.tmbk` file will be saved
4. Tap **"Restore from File"** to restore

---

## 🔧 Configuration

### Change Package Name
Edit `android/app/build.gradle`:
```gradle
defaultConfig {
    applicationId "com.yourname.taskmanager"
    ...
}
```

### Change App Icon
Update icons in:
- `android/app/src/main/res/` for Android
- `ios/Runner/Assets.xcassets/` for iOS

---

## 📱 Supported Platforms

| Platform | Status |
|---|---|
| ✅ Android | Supported |
| ✅ iOS | Supported |
| ✅ Windows | Supported |
| ✅ macOS | Supported |
| ✅ Linux | Supported |
| ✅ Web | Supported |

---

## 📄 License

This project is created for educational purposes.

---

## 👨‍💻 Author

**Task Manager App**  
Flutter Development Project

---

<div align="center">

**Made with ❤️ and Flutter**

</div>
