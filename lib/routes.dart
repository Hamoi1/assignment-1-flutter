import 'package:get/get.dart';
import '../views/splash_screen.dart';
import '../views/home_screen.dart';
import '../views/add_task_screen.dart';
import '../views/task_details_screen.dart';
import '../views/settings_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';
  static const String addTask = '/add';
  static const String taskDetails = '/details';
  static const String settings = '/settings';

  static final routes = [
    GetPage(name: splash, page: () => const SplashScreen()),
    GetPage(name: home, page: () => const HomeScreen()),
    GetPage(name: addTask, page: () => const AddTaskScreen()),
    GetPage(name: taskDetails, page: () => const TaskDetailsScreen()),
    GetPage(name: settings, page: () => const SettingsScreen()),
  ];
}
