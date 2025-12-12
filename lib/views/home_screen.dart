import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import '../controllers/task_controller.dart';
import '../controllers/backup_controller.dart';
import '../models/task_model.dart';
import '../theme/theme_service.dart';
import '../theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final TaskController taskController;
  late final BackupController backupController;
  int? _currentIndex;
  static const List<String> _titles = [
    'ڕێکخستن',
    'زیادکردنی ئەرک',
    'ئەرکەکانم',
  ];

  @override
  void initState() {
    super.initState();
    taskController = Get.put(TaskController(), permanent: true);
    backupController = Get.put(BackupController(), permanent: true);
    _currentIndex = 2;
  }

  @override
  Widget build(BuildContext context) {
    final int safeIndex = (_currentIndex ?? 2).clamp(0, _titles.length - 1);
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_titles[safeIndex]),
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
        body: IndexedStack(
          index: safeIndex,
          children: const [_SettingsTab(), _AddTaskTab(), _HomeTab()],
        ),
        bottomNavigationBar: GetBuilder<ThemeService>(
          builder: (_) => CurvedNavigationBar(
            index: safeIndex,
            backgroundColor: Colors.transparent,
            color: Theme.of(context).colorScheme.primary,
            buttonBackgroundColor: Theme.of(context).colorScheme.secondary,
            height: 62,
            animationDuration: const Duration(milliseconds: 220),
            animationCurve: Curves.easeOutCubic,
            items: const [
              Icon(Icons.settings, color: Colors.white, size: 26),
              Icon(Icons.add, color: Colors.white, size: 28),
              Icon(Icons.home, color: Colors.white, size: 26),
            ],
            onTap: (index) {
              setState(() => _currentIndex = index);
            },
            letIndexChange: (i) => true,
          ),
        ),
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    final taskController = Get.find<TaskController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: isDark
                    ? [
                        Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.12),
                        Theme.of(
                          context,
                        ).colorScheme.secondary.withValues(alpha: 0.08),
                      ]
                    : [
                        Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.04),
                        Theme.of(
                          context,
                        ).colorScheme.secondary.withValues(alpha: 0.02),
                      ],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.05)
                    : Theme.of(
                        context,
                      ).colorScheme.outline.withValues(alpha: 0.3),
              ),
            ),
            child: TextField(
              onChanged: (value) => taskController.searchTasks(value),
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 15),
              decoration: InputDecoration(
                hintText: 'گەڕان بە دوای ئەرکەکاندا...',
                hintStyle: const TextStyle(fontSize: 15),
                prefixIcon: const Icon(Icons.search, size: 22),
                suffixIcon: GetBuilder<TaskController>(
                  builder: (controller) =>
                      controller.searchQuery.value.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            controller.searchTasks('');
                            FocusScope.of(context).unfocus();
                          },
                        )
                      : const SizedBox(),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : Theme.of(context).colorScheme.surface,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 48,
          child: GetBuilder<TaskController>(
            builder: (controller) => ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: controller.categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final category = controller.categories[index];
                final isSelected =
                    controller.selectedCategory.value == category;
                return _CategoryFilterButton(
                  label: category,
                  color: AppTheme.getCategoryColor(category),
                  selected: isSelected,
                  onTap: () => controller.filterByCategory(category),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GetBuilder<TaskController>(
            builder: (controller) => Row(
              children: [
                Expanded(
                  child: _StatCard(
                    title: 'گشتی',
                    count: controller.tasks.length,
                    icon: Icons.task_alt,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _StatCard(
                    title: 'تەواوبوو',
                    count: controller.completedTasksCount,
                    icon: Icons.check_circle,
                    color: const Color(0xFF14B8A6),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _StatCard(
                    title: 'چاوەڕێ',
                    count: controller.pendingTasksCount,
                    icon: Icons.schedule,
                    color: const Color(0xFFF97316),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        Expanded(
          // REPLACED ClipRRect with a transparent Container
          child: GetBuilder<TaskController>(
            builder: (controller) {
              final tasks = controller.filteredTasks;
              if (tasks.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.task_outlined,
                        size: 80,
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.35),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'هیچ ئەرکێک نییە',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'کلیک لە + بکە بۆ زیادکردنی یەکەم ئەرک',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.only(
                  bottom: 100,
                  top: 8,
                  left: 16,
                  right: 16,
                ),
                physics: const BouncingScrollPhysics(),
                itemCount: tasks.length,
                separatorBuilder: (context, index) => const SizedBox(height: 6),
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return _TaskCard(task: task);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SettingsTab extends StatelessWidget {
  const _SettingsTab();

  @override
  Widget build(BuildContext context) {
    final backupController = Get.find<BackupController>();
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
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
    );
  }
}

class _AddTaskTab extends StatefulWidget {
  const _AddTaskTab();

  @override
  State<_AddTaskTab> createState() => _AddTaskTabState();
}

class _AddTaskTabState extends State<_AddTaskTab> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _selectedCategory = 'کار';
  DateTime _selectedDate = DateTime.now();

  final List<String> _categories = ['کار', 'کەسی', 'کڕین', 'تەندروستی', 'هیتر'];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      final taskController = Get.find<TaskController>();

      final newTask = TaskModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        category: _selectedCategory,
        date: _selectedDate,
      );

      taskController.addTask(newTask);
      _titleController.clear();
      _descriptionController.clear();
      setState(() {
        _selectedCategory = 'کار';
        _selectedDate = DateTime.now();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ناونیشان',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _titleController,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 16),
              decoration: InputDecoration(
                hintText: 'ناونیشانی ئەرک بنووسە',
                prefixIcon: const Icon(Icons.title),
                errorStyle: const TextStyle(
                  color: Color(0xFFEF4444),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFFEF4444),
                    width: 2,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFFEF4444),
                    width: 2,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'تکایە ناونیشان بنووسە';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            Text(
              'وەسف',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _descriptionController,
              textAlign: TextAlign.right,
              decoration: const InputDecoration(
                hintText: 'وەسفی ئەرک بنووسە (دڵخواز)',
                prefixIcon: Icon(Icons.description),
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 24),
            Text(
              'جۆر',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.end,
              children: _categories.map((category) {
                final isSelected = _selectedCategory == category;
                final categoryColor = AppTheme.getCategoryColor(category);

                return InkWell(
                  onTap: () {
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? categoryColor
                          : categoryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: categoryColor,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Text(
                      category,
                      style: TextStyle(
                        color: isSelected ? Colors.white : categoryColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            Text(
              'بەرواری کۆتایی',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: _selectDate,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today),
                    const SizedBox(width: 12),
                    Text(
                      DateFormat('yyyy/MM/dd').format(_selectedDate),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveTask,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('پاشەکەوتکردن'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryFilterButton extends StatelessWidget {
  final String label;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryFilterButton({
    required this.label,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseTextColor =
        theme.textTheme.bodySmall?.color ?? theme.colorScheme.onSurface;
    final isDark = theme.brightness == Brightness.dark;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        gradient: selected
            ? LinearGradient(
                colors: [color, color.withValues(alpha: 0.7)],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              )
            : null,
        color: selected
            ? null
            : (isDark
                  ? theme.colorScheme.surfaceContainerHighest.withValues(
                      alpha: 0.6,
                    )
                  : theme.colorScheme.surfaceContainerHighest.withValues(
                      alpha: 0.8,
                    )),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: selected ? color : theme.dividerColor.withValues(alpha: 0.5),
          width: 1,
        ),
        boxShadow: selected
            ? [
                BoxShadow(
                  color: color.withValues(alpha: isDark ? 0.3 : 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ]
            : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selected
                        ? Colors.white
                        : color.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: selected ? Colors.white : baseTextColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
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
      padding: const EdgeInsets.only(bottom: 10, right: 4),
      child: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
        textAlign: TextAlign.right,
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final int count;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 300),
      tween: Tween(begin: 0.96, end: 1),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: LinearGradient(
                colors: isDark
                    ? [
                        color.withValues(alpha: 0.25),
                        color.withValues(alpha: 0.08),
                      ]
                    : [
                        color.withValues(alpha: 0.12),
                        color.withValues(alpha: 0.04),
                      ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: color.withValues(alpha: isDark ? 0.2 : 0.15),
                width: 1,
              ),
              boxShadow: isDark
                  ? [
                      BoxShadow(
                        color: color.withValues(alpha: 0.12),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: color.withValues(alpha: 0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 3),
                      ),
                    ],
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: isDark ? 0.18 : 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 18),
                ),
                const SizedBox(height: 6),
                Text(
                  count.toString(),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: color,
                  ),
                ),
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _TaskCard extends StatelessWidget {
  final TaskModel task;

  const _TaskCard({required this.task});

  @override
  Widget build(BuildContext context) {
    final taskController = Get.find<TaskController>();
    final categoryColor = AppTheme.getCategoryColor(task.category);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        // Glassmorphism effect
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  const Color(0xFF1E293B).withValues(alpha: 0.7),
                  const Color(0xFF0F172A).withValues(alpha: 0.5),
                ]
              : [Colors.white, Colors.white.withValues(alpha: 0.9)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : categoryColor.withValues(alpha: task.isCompleted ? 0.1 : 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.3)
                : categoryColor.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
          if (!isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showTaskDetailsModal(context, task),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Top Row: Category badge + Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Action buttons row (left in RTL)
                    Row(
                      children: [
                        // Delete button
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => taskController.deleteTask(task.id),
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.red.withValues(
                                  alpha: isDark ? 0.15 : 0.08,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.delete_outline_rounded,
                                color: Colors.red.withValues(alpha: 0.7),
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Pin button
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => taskController.togglePin(task.id),
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: task.isPinned
                                    ? Colors.amber.withValues(
                                        alpha: isDark ? 0.25 : 0.15,
                                      )
                                    : (isDark
                                          ? Colors.white.withValues(alpha: 0.08)
                                          : Colors.black.withValues(
                                              alpha: 0.05,
                                            )),
                                borderRadius: BorderRadius.circular(10),
                                border: task.isPinned
                                    ? Border.all(
                                        color: Colors.amber.withValues(
                                          alpha: 0.4,
                                        ),
                                        width: 1,
                                      )
                                    : null,
                              ),
                              child: Icon(
                                task.isPinned
                                    ? Icons.push_pin
                                    : Icons.push_pin_outlined,
                                color: task.isPinned
                                    ? Colors.amber
                                    : (isDark ? Colors.white54 : Colors.grey),
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Category badge (right in RTL)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            categoryColor.withValues(
                              alpha: isDark ? 0.25 : 0.15,
                            ),
                            categoryColor.withValues(
                              alpha: isDark ? 0.15 : 0.08,
                            ),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: categoryColor.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            task.category,
                            style: TextStyle(
                              color: categoryColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: categoryColor,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: categoryColor.withValues(alpha: 0.5),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // Title Row with Checkbox
                Row(
                  children: [
                    // Animated Checkbox
                    GestureDetector(
                      onTap: () {
                        final updatedTask = task.copyWith(
                          isCompleted: !task.isCompleted,
                        );
                        taskController.updateTask(updatedTask);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOutCubic,
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          gradient: task.isCompleted
                              ? const LinearGradient(
                                  colors: [
                                    Color(0xFF14B8A6),
                                    Color(0xFF0D9488),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                              : null,
                          color: task.isCompleted ? null : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: task.isCompleted
                                ? Colors.transparent
                                : (isDark
                                      ? Colors.white.withValues(alpha: 0.3)
                                      : categoryColor.withValues(alpha: 0.4)),
                            width: 2,
                          ),
                          boxShadow: task.isCompleted
                              ? [
                                  BoxShadow(
                                    color: const Color(
                                      0xFF14B8A6,
                                    ).withValues(alpha: 0.4),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : null,
                        ),
                        child: task.isCompleted
                            ? const Icon(
                                Icons.check_rounded,
                                size: 16,
                                color: Colors.white,
                              )
                            : null,
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Title
                    Expanded(
                      child: Text(
                        task.title,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 17,
                          decoration: task.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                          decorationColor: Theme.of(context).disabledColor,
                          color: task.isCompleted
                              ? Theme.of(context).disabledColor
                              : (isDark
                                    ? Colors.white
                                    : const Color(0xFF1E293B)),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),

                // Description (if exists)
                if (task.description.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    task.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.6)
                          : const Color(0xFF64748B),
                      fontSize: 13,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                  ),
                ],

                const SizedBox(height: 12),

                // Bottom Row: Date
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.05)
                        : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        DateFormat('MMM dd, yyyy').format(task.date),
                        style: TextStyle(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.7)
                              : const Color(0xFF64748B),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(
                        Icons.event_rounded,
                        size: 14,
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.5)
                            : const Color(0xFF94A3B8),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void _showTaskDetailsModal(BuildContext context, TaskModel task) {
  final categoryColor = AppTheme.getCategoryColor(task.category);
  final taskController = Get.find<TaskController>();
  final isDark = Theme.of(context).brightness == Brightness.dark;

  // Track local completion state for reactive UI
  bool isCompleted = task.isCompleted;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => Container(
        height: MediaQuery.of(context).size.height * 0.55,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
                : [Colors.white, const Color(0xFFF8FAFC)],
          ),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          children: [
            // Drag handle
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? Colors.white24 : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header Card
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [categoryColor, categoryColor.withValues(alpha: 0.8)],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: categoryColor.withValues(alpha: 0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Top row: Close button + Category + Status
                  Row(
                    children: [
                      // Close button
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.close_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                          padding: const EdgeInsets.all(8),
                          constraints: const BoxConstraints(),
                        ),
                      ),
                      const Spacer(),
                      // Completion status badge
                      if (isCompleted)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          margin: const EdgeInsets.only(left: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.25),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'تەواوبوو',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(
                                Icons.check_circle,
                                color: Colors.white,
                                size: 14,
                              ),
                            ],
                          ),
                        ),
                      // Category badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text(
                          task.category,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Title
                  Text(
                    task.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      decoration: isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                      decorationColor: Colors.white.withValues(alpha: 0.7),
                    ),
                    textAlign: TextAlign.right,
                  ),

                  // Description
                  if (task.description.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Text(
                      task.description,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 14,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ],

                  const SizedBox(height: 16),

                  // Date pill
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          DateFormat('yyyy/MM/dd').format(task.date),
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.95),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.event_rounded,
                          color: Colors.white.withValues(alpha: 0.9),
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Action Buttons
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
              child: Row(
                children: [
                  // Delete Button
                  Expanded(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context); // Close modal first
                          taskController.deleteTask(task.id); // Then delete
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.red.shade400,
                                Colors.red.shade600,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.red.withValues(alpha: 0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.delete_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'سڕینەوە',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Toggle Complete Button (reactive)
                  Expanded(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          // Update local state immediately for UI
                          setState(() {
                            isCompleted = !isCompleted;
                          });
                          // Update in controller
                          taskController.toggleTaskCompletion(task.id);
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOutCubic,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isCompleted
                                  ? [
                                      Colors.orange.shade400,
                                      Colors.orange.shade600,
                                    ]
                                  : [
                                      const Color(0xFF10B981),
                                      const Color(0xFF059669),
                                    ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    (isCompleted
                                            ? Colors.orange
                                            : const Color(0xFF10B981))
                                        .withValues(alpha: 0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 200),
                                child: Icon(
                                  isCompleted
                                      ? Icons.replay_rounded
                                      : Icons.check_rounded,
                                  key: ValueKey(isCompleted),
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 8),
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 200),
                                child: Text(
                                  isCompleted ? 'گەڕانەوە' : 'تەواو',
                                  key: ValueKey(isCompleted),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
