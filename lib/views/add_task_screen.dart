import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import '../controllers/task_controller.dart';
import '../models/task_model.dart';
import '../theme/app_theme.dart';
import '../theme/theme_service.dart';
import '../routes.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
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
      // Initialize TaskController if not already initialized
      final taskController = Get.put(TaskController());

      final newTask = TaskModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        category: _selectedCategory,
        date: _selectedDate,
      );

      // Navigate back to home (clear navigation stack)
      Get.offAllNamed('/home');

      // Then add task with notification
      Future.delayed(const Duration(milliseconds: 300), () {
        taskController.addTask(newTask);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('زیادکردنی ئەرکی نوێ'),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title field
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

              // Description field
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

              // Category selector
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

              // Date picker
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
                      Icon(
                        Icons.calendar_today,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        DateFormat('EEEE, MMMM dd, yyyy').format(_selectedDate),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const Spacer(),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Save button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveTask,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('پاشەکەوتکردنی ئەرک'),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: GetBuilder<ThemeService>(
        builder: (_) => CurvedNavigationBar(
          index: 1,
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
            if (index == 0) {
              Get.offAllNamed(AppRoutes.settings);
            } else if (index == 2) {
              Get.offAllNamed(AppRoutes.home);
            }
          },
        ),
      ),
    );
  }
}
