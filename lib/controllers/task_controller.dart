import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/task_model.dart';
import '../utils/glassy_snackbar.dart';

class TaskController extends GetxController {
  final _storage = GetStorage();
  final _tasksKey = 'tasks';

  // Observable list of tasks
  final RxList<TaskModel> tasks = <TaskModel>[].obs;
  final RxList<TaskModel> filteredTasks = <TaskModel>[].obs;
  final RxString searchQuery = ''.obs;
  final RxString selectedCategory = 'هەموو'.obs;

  // Categories
  final List<String> categories = [
    'هەموو',
    'کار',
    'کەسی',
    'کڕین',
    'تەندروستی',
    'هیتر',
  ];

  @override
  void onInit() {
    super.onInit();
    loadTasks();
  }

  // Load tasks from storage
  void loadTasks() {
    try {
      final tasksData = _storage.read(_tasksKey);
      if (tasksData != null) {
        final List<dynamic> tasksList = jsonDecode(tasksData);
        tasks.value = tasksList
            .map((task) => TaskModel.fromJson(task))
            .toList();
        _applyFilters();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load tasks: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Save tasks to storage
  void saveTasks() {
    try {
      final tasksJson = jsonEncode(tasks.map((task) => task.toJson()).toList());
      _storage.write(_tasksKey, tasksJson);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save tasks: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Replace all tasks (used for restoring backups)
  void replaceAllTasks(List<TaskModel> newTasks) {
    tasks.assignAll(newTasks);
    saveTasks();
    _applyFilters();
  }

  // Add task
  void addTask(TaskModel task) {
    tasks.add(task);
    saveTasks();
    _applyFilters();

    showSuccessSnackbar('سەرکەوتوو', 'ئەرکی "${task.title}" زیادکرا');
  }

  // Update task
  void updateTask(TaskModel updatedTask) {
    final index = tasks.indexWhere((task) => task.id == updatedTask.id);
    if (index != -1) {
      tasks[index] = updatedTask;
      saveTasks();
      _applyFilters();
      showInfoSnackbar('سەرکەوتوو', 'ئەرک نوێکرایەوە');
    }
  }

  // Delete task
  void deleteTask(String taskId) {
    final taskToDelete = tasks.firstWhere((task) => task.id == taskId);
    final taskIndex = tasks.indexWhere((task) => task.id == taskId);

    tasks.removeWhere((task) => task.id == taskId);
    saveTasks();
    _applyFilters();

    showDeleteSnackbar(
      title: 'سڕایەوە',
      message: '"${taskToDelete.title}" لابرا',
      onUndo: () {
        if (Get.isSnackbarOpen) Get.back();
        tasks.insert(taskIndex, taskToDelete);
        saveTasks();
        _applyFilters();
        showSuccessSnackbar('گەڕایەوە', '"${taskToDelete.title}" گەڕایەوە');
      },
    );
  }

  // Toggle task completion
  void toggleTaskCompletion(String taskId) {
    final index = tasks.indexWhere((task) => task.id == taskId);
    if (index != -1) {
      tasks[index].isCompleted = !tasks[index].isCompleted;
      saveTasks();
      _applyFilters();

      if (tasks[index].isCompleted) {
        showSuccessSnackbar(
          'تەواوبوو',
          '"${tasks[index].title}" وەک تەواوبوو نیشانکرا',
        );
      } else {
        showWarningSnackbar(
          'تەواونەبوو',
          '"${tasks[index].title}" وەک تەواونەبوو نیشانکرا',
        );
      }
    }
  }

  // Toggle task pin status
  void togglePin(String taskId) {
    final index = tasks.indexWhere((task) => task.id == taskId);
    if (index != -1) {
      tasks[index].isPinned = !tasks[index].isPinned;
      saveTasks();
      _applyFilters();

      if (tasks[index].isPinned) {
        showInfoSnackbar(
          '📌 پینکرا',
          '"${tasks[index].title}" پینکرا بۆ سەرەوە',
        );
      } else {
        showInfoSnackbar('📌 لابرا', '"${tasks[index].title}" پینی لابرا');
      }
    }
  }

  // Search tasks
  void searchTasks(String query) {
    searchQuery.value = query;
    _applyFilters();
  }

  // Filter by category
  void filterByCategory(String category) {
    selectedCategory.value = category;
    _applyFilters();
  }

  // Apply filters (search + category)
  void _applyFilters() {
    List<TaskModel> result = tasks.toList();

    // Filter by category
    if (selectedCategory.value != 'هەموو') {
      result = result
          .where((task) => task.category == selectedCategory.value)
          .toList();
    }

    // Filter by search query
    if (searchQuery.value.isNotEmpty) {
      result = result.where((task) {
        return task.title.toLowerCase().contains(
              searchQuery.value.toLowerCase(),
            ) ||
            task.description.toLowerCase().contains(
              searchQuery.value.toLowerCase(),
            );
      }).toList();
    }

    // Sort by date (newest first)
    result.sort((a, b) => b.date.compareTo(a.date));

    // Sort pinned tasks to top (keeping date order within pinned/unpinned)
    result.sort((a, b) {
      if (a.isPinned && !b.isPinned) return -1;
      if (!a.isPinned && b.isPinned) return 1;
      return 0;
    });

    filteredTasks.value = result;
    update(); // Notify GetBuilder listeners
  }

  // Get task by ID
  TaskModel? getTaskById(String id) {
    try {
      return tasks.firstWhere((task) => task.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get completed tasks count
  int get completedTasksCount => tasks.where((task) => task.isCompleted).length;

  // Get pending tasks count
  int get pendingTasksCount => tasks.where((task) => !task.isCompleted).length;

  // Get tasks for today
  List<TaskModel> get todayTasks {
    final now = DateTime.now();
    return tasks.where((task) {
      return task.date.year == now.year &&
          task.date.month == now.month &&
          task.date.day == now.day;
    }).toList();
  }
}
