import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'controllers/backup_controller.dart';
import 'theme/app_theme.dart';
import 'theme/theme_service.dart';
import 'routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize GetStorage
  await GetStorage.init();

  // Initialize ThemeService first
  Get.put(ThemeService(), permanent: true);
  // Ensure backup controller is ready even if Settings opens first
  Get.put(BackupController(), permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeService>(
      init: Get.find<ThemeService>(),
      builder: (themeService) {
        return GetMaterialApp(
          title: 'بەڕێوەبەری ئەرکەکان',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeService.themeMode,
          initialRoute: AppRoutes.splash,
          getPages: AppRoutes.routes,
          // Add RTL support for Kurdish
          locale: const Locale('ku', 'IQ'),
          fallbackLocale: const Locale('en', 'US'),
          builder: (context, child) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: child!,
            );
          },
        );
      },
    );
  }
}
