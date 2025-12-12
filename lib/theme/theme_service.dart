import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeService extends GetxController {
  final _storage = GetStorage();
  final _key = 'isDarkMode';

  // Observable theme mode
  final Rx<ThemeMode> _themeMode = ThemeMode.light.obs;
  ThemeMode get themeMode => _themeMode.value;

  @override
  void onInit() {
    super.onInit();
    _loadThemeFromStorage();
  }

  // Load theme from storage
  void _loadThemeFromStorage() {
    final isDark = _storage.read(_key) ?? false;
    _themeMode.value = isDark ? ThemeMode.dark : ThemeMode.light;
  }

  // Toggle theme
  void toggleTheme() {
    _themeMode.value = _themeMode.value == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    _saveThemeToStorage();
    Get.changeThemeMode(_themeMode.value);
    update(); // Notify listeners
  }

  // Save theme to storage
  void _saveThemeToStorage() {
    _storage.write(_key, _themeMode.value == ThemeMode.dark);
  }

  // Check if dark mode
  bool get isDarkMode => _themeMode.value == ThemeMode.dark;
}
