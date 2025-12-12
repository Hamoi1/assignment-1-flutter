import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/task_controller.dart';
import '../models/task_model.dart';
import '../theme/app_theme.dart';

class TaskDetailsScreen extends StatefulWidget {
  const TaskDetailsScreen({super.key});

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  late String _selectedCategory;
  late DateTime _selectedDate;
  late bool _isCompleted;
  late TaskModel _task;
  late final TaskController taskController;

  bool _isEditing = false;
  final List<String> _categories = ['کار', 'کەسی', 'کڕین', 'تەندروستی', 'هیتر'];

  @override
  void initState() {
    super.initState();
    taskController = Get.find<TaskController>();
    _loadTask();
  }

  void _loadTask() {
    final taskId = Get.parameters['id'] ?? '';

    final task = taskController.getTaskById(taskId);
    if (task == null) {
      Get.back();
      return;
    }

    _task = task;
    _titleController = TextEditingController(text: task.title);
    _descriptionController = TextEditingController(text: task.description);
    _selectedCategory = task.category;
    _selectedDate = task.date;
    _isCompleted = task.isCompleted;
  }

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

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      final updatedTask = _task.copyWith(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        category: _selectedCategory,
        date: _selectedDate,
        isCompleted: _isCompleted,
      );

      taskController.updateTask(updatedTask);
      setState(() {
        _isEditing = false;
        _task = updatedTask;
      });
    }
  }

  void _deleteTask() {
    taskController.deleteTask(_task.id);
    Get.back(); // Close details screen
  }

  @override
  Widget build(BuildContext context) {
    final categoryColor = AppTheme.getCategoryColor(_selectedCategory);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'دەستکاری ئەرک' : 'وردەکاری ئەرک'),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  _isEditing = true;
                });
              },
            ),
          IconButton(icon: const Icon(Icons.delete), onPressed: _deleteTask),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Completion status
              Card(
                child: SwitchListTile(
                  title: const Text('تەواوبوو؟'),
                  value: _isCompleted,
                  onChanged: _isEditing
                      ? (value) {
                          setState(() {
                            _isCompleted = value;
                          });
                        }
                      : null,
                  secondary: Icon(
                    _isCompleted
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    color: _isCompleted ? Colors.green : Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Title
              Text(
                'ناونیشان',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                enabled: _isEditing,
                decoration: const InputDecoration(
                  hintText: 'ناونیشانی ئەرک بنووسە',
                  prefixIcon: Icon(Icons.title),
                ),
                style: TextStyle(
                  decoration: _isCompleted ? TextDecoration.lineThrough : null,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'تکایە ناونیشان بنووسە';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Description
              Text(
                'وەسف',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                enabled: _isEditing,
                decoration: const InputDecoration(
                  hintText: 'وەسفی ئەرک بنووسە (دڵخواز)',
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 24),

              // Category
              Text(
                'جۆر',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              if (_isEditing)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _categories.map((category) {
                    final isSelected = _selectedCategory == category;
                    final catColor = AppTheme.getCategoryColor(category);

                    return ChoiceChip(
                      label: Text(category),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedCategory = category;
                          });
                        }
                      },
                      selectedColor: catColor.withValues(alpha: 0.3),
                      labelStyle: TextStyle(
                        color: isSelected ? catColor : null,
                        fontWeight: isSelected ? FontWeight.w600 : null,
                      ),
                      side: BorderSide(
                        color: isSelected ? catColor : Colors.grey.shade300,
                      ),
                    );
                  }).toList(),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: categoryColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _selectedCategory,
                    style: TextStyle(
                      color: categoryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              const SizedBox(height: 24),

              // Date
              Text(
                'بەرواری کۆتایی',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: _isEditing ? _selectDate : null,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _isEditing
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey.shade300,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: _isEditing
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        DateFormat('yyyy/MM/dd').format(_selectedDate),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      if (_isEditing) ...[
                        const Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Save button (only shown when editing)
              if (_isEditing)
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _saveChanges,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('پاشەکەوتکردنی گۆرانکاری'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _isEditing = false;
                            _loadTask(); // Reset to original values
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('پەشیمانم'),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
