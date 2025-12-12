import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import '../controllers/backup_controller.dart';
import '../theme/theme_service.dart';
import '../routes.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final BackupController backupController;

  @override
  void initState() {
    super.initState();
    backupController = Get.find<BackupController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ڕێکخستنەکان'),
        automaticallyImplyLeading: false,
        actions: [
          GetBuilder<ThemeService>(
            builder: (themeService) => IconButton(
              icon: Icon(
                themeService.isDarkMode ? Icons.light_mode : Icons.dark_mode,
              ),
              onPressed: () => themeService.toggleTheme(),
              tooltip: 'گۆڕینی ڕووناکی',
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Appearance Section
          _SectionHeader(title: 'ڕووکار'),
          Card(
            child: GetBuilder<ThemeService>(
              builder: (themeService) => SwitchListTile(
                title: const Text('دۆخی تاریک'),
                subtitle: const Text('گۆڕین لە نێوان ڕووناکی و تاریکی'),
                value: themeService.isDarkMode,
                onChanged: (value) => themeService.toggleTheme(),
                secondary: Icon(
                  themeService.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Local Backup Section
          _SectionHeader(title: 'پاشەکەوتی ناوخۆ'),

          Obx(() {
            final isBusy = backupController.isBackupInProgress.value;
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.shield_outlined,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'پاشەکەوت و گەڕاندنەوە',
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'فایلەکە بە .tmbk پاشەکەوت دەبێت بۆ پاراستنی داتا',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: Theme.of(context).hintColor,
                                    ),
                                textAlign: TextAlign.right,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      alignment: WrapAlignment.end,
                      children: [
                        ElevatedButton.icon(
                          onPressed: isBusy
                              ? null
                              : () => backupController.exportBackup(),
                          icon: const Icon(Icons.download_rounded),
                          label: Text(isBusy ? 'چاوەڕێ بکە' : 'داگرتنی داتا'),
                        ),
                        OutlinedButton.icon(
                          onPressed: isBusy
                              ? null
                              : () => backupController.importBackup(),
                          icon: const Icon(Icons.restore),
                          label: const Text('گەڕاندنەوە لە فایل'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'دوایین پاشەکەوت: ${backupController.formattedLastBackupTime}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).hintColor,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 24),

          // About Section
          _SectionHeader(title: 'دەربارە'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('وەشان'),
                  subtitle: const Text('1.0.0'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.developer_mode),
                  title: const Text('پەرەپێدەر'),
                  subtitle: const Text('ئەپەی بەڕێوەبەری ئەرک'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Help Section
          _SectionHeader(title: 'یارمەتی و پشتگیری'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.help_outline),
                  title: const Text('یارمەتی و پرسیارە باوەکان'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Get.dialog(
                      AlertDialog(
                        title: const Text('یارمەتی و پرسیارە باوەکان'),
                        content: const SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'چۆن بەکارهێنانی بەڕێوەبەری ئەرکەکان:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 8),
                              Text('1. ئەرکێک زیاد بکە بە دوگمەی +'),
                              Text(
                                '2. ئەرکە تەواوبووکان نیشانە بکە بە دوگمەی پشکنین',
                              ),
                              Text('3. بەپێی جۆرەکان بێلکەرەوە'),
                              Text('4. بە دوای ناونیشان بگەڕێ'),
                              Text('5. داتاکانت پاشەکەوت بکە بۆ پەڕگەی .tmbk'),
                              SizedBox(height: 16),
                              Text(
                                'پاشەکەوتی ناوخۆ:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'فایلەکان بە پسندی .tmbk پاشەکەوت دەبن بۆ پاراستن. هەمان پەڕگە پێویستە بۆ گەڕاندنەوە و هەڵەی پسند وەردەگیرێت.',
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Get.back(),
                            child: const Text('داخستن'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.bug_report_outlined),
                  title: const Text('ڕاپۆرتی هەڵە'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Get.snackbar(
                      'ڕاپۆرت',
                      'تکایە نامە بنێرە بۆ support@taskmanager.com',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: GetBuilder<ThemeService>(
        builder: (_) => CurvedNavigationBar(
          index: 0,
          backgroundColor: Colors.transparent,
          color: Theme.of(context).colorScheme.primary,
          buttonBackgroundColor: Theme.of(context).colorScheme.secondary,
          height: 60,
          animationDuration: const Duration(milliseconds: 300),
          items: const [
            Icon(Icons.settings, color: Colors.white, size: 26),
            Icon(Icons.add, color: Colors.white, size: 28),
            Icon(Icons.home, color: Colors.white, size: 26),
          ],
          onTap: (index) {
            if (index == 0) return;
            if (index == 1) {
              Get.offAllNamed(AppRoutes.addTask);
            } else {
              Get.offAllNamed(AppRoutes.home);
            }
          },
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, right: 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
