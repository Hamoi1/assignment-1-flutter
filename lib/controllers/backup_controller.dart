import 'dart:convert';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/task_model.dart';
import 'task_controller.dart';

class BackupController extends GetxController {
  static const _signature = 'TMBK::';
  final _storage = GetStorage();
  final RxBool isBackupInProgress = false.obs;
  final RxString lastBackupTime = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadLastBackupTime();
  }

  void _loadLastBackupTime() {
    lastBackupTime.value = _storage.read('lastBackupTime') ?? '';
  }

  Future<void> exportBackup() async {
    if (isBackupInProgress.value) return;

    try {
      isBackupInProgress.value = true;
      final taskController = Get.find<TaskController>();

      final backupData = {
        'last_updated': DateTime.now().toIso8601String(),
        'tasks': taskController.tasks.map((task) => task.toJson()).toList(),
      };

      final encoded = base64Url.encode(utf8.encode(jsonEncode(backupData)));
      final payload = '$_signature$encoded';
      final bytes = Uint8List.fromList(payload.codeUnits);
      final fileName = 'tasks_backup_${DateTime.now().millisecondsSinceEpoch}';

      await FileSaver.instance.saveFile(
        name: fileName,
        bytes: bytes,
        ext: 'tmbk',
        mimeType: MimeType.other,
      );

      lastBackupTime.value = DateTime.now().toIso8601String();
      _storage.write('lastBackupTime', lastBackupTime.value);

      Get.snackbar(
        'سەرکەوتوو',
        'داتاکانت بە سەرکەوتوویی پاشەکەوت کران',
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      Get.snackbar(
        'هەڵە',
        'نەتوانرا داتا پاشەکەوت بکرێت: $e',
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isBackupInProgress.value = false;
    }
  }

  Future<void> importBackup() async {
    if (isBackupInProgress.value) return;

    try {
      isBackupInProgress.value = true;

      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['tmbk'],
        withData: true,
      );

      if (result == null || result.files.isEmpty) {
        return; // User cancelled
      }

      final file = result.files.single;
      final extension = (file.extension ?? '').toLowerCase();

      if (extension != 'tmbk') {
        throw Exception('فایلی هەڵبژێردراو دروست نیە');
      }

      final bytes = file.bytes;
      if (bytes == null) {
        throw Exception('نەتوانرا ناوەڕۆک بخوێندرێت');
      }

      final content = utf8.decode(bytes);
      if (!content.startsWith(_signature)) {
        throw Exception('فایلەکە خراپە یان گۆڕاوە');
      }

      final encoded = content.substring(_signature.length);
      final decodedJson = utf8.decode(base64Url.decode(encoded));
      final data = jsonDecode(decodedJson);

      final tasksJson = data['tasks'] as List<dynamic>;
      final restoredTasks = tasksJson
          .map((task) => TaskModel.fromJson(task as Map<String, dynamic>))
          .toList();

      final taskController = Get.find<TaskController>();
      taskController.replaceAllTasks(restoredTasks);

      lastBackupTime.value = data['last_updated'] ?? '';
      _storage.write('lastBackupTime', lastBackupTime.value);

      Get.snackbar(
        'گەڕاندنەوە',
        'داتاکانت گەڕێندرایەوە لە فایل',
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      Get.snackbar(
        'هەڵە',
        'نەتوانرا داتای گەڕێندراو بخوێندرێت: $e',
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isBackupInProgress.value = false;
    }
  }

  String get formattedLastBackupTime {
    if (lastBackupTime.value.isEmpty) {
      return 'هێشتا نییە';
    }
    try {
      final time = DateTime.parse(lastBackupTime.value);
      final now = DateTime.now();
      final difference = now.difference(time);

      if (difference.inMinutes < 1) {
        return 'ئێستا';
      } else if (difference.inHours < 1) {
        return '${difference.inMinutes} خولەک پێش';
      } else if (difference.inDays < 1) {
        return '${difference.inHours} کاتژمێر پێش';
      } else {
        return '${difference.inDays} رۆژ پێش';
      }
    } catch (e) {
      return 'نادیار';
    }
  }
}
