import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/task_model.dart';

class TaskProvider extends ChangeNotifier {
  final Box tasksBox = Hive.box('tasksBox');
  final Uuid uuid = const Uuid();

  List<TaskModel> _tasks = [];
  String _searchQuery = '';
  String _selectedStatus = 'All';
  bool isLoading = false;

  List<TaskModel> get tasks {
    List<TaskModel> filteredTasks = _tasks;

    if (_searchQuery.isNotEmpty) {
      filteredTasks = filteredTasks.where((task) {
        return task.title.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    if (_selectedStatus != 'All') {
      filteredTasks = filteredTasks.where((task) {
        return task.status == _selectedStatus;
      }).toList();
    }

    return filteredTasks;
  }

  String get selectedStatus => _selectedStatus;

  void loadTasks() {
    final data = tasksBox.values.toList();

    _tasks = data.map((task) {
      return TaskModel.fromMap(Map<String, dynamic>.from(task));
    }).toList();

    notifyListeners();
  }

  Future<void> addTask({
    required String title,
    required String description,
    required DateTime dueDate,
    required String status,
    String? blockedByTaskId,
  }) async {
    isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    final task = TaskModel(
      id: uuid.v4(),
      title: title,
      description: description,
      dueDate: dueDate,
      status: status,
      blockedByTaskId: blockedByTaskId,
    );

    await tasksBox.put(task.id, task.toMap());

    loadTasks();

    isLoading = false;
    notifyListeners();
  }

  Future<void> updateTask(TaskModel task) async {
    isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    await tasksBox.put(task.id, task.toMap());

    loadTasks();

    isLoading = false;
    notifyListeners();
  }

  Future<void> deleteTask(String id) async {
    await tasksBox.delete(id);
    loadTasks();
  }

  void searchTasks(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void filterTasks(String status) {
    _selectedStatus = status;
    notifyListeners();
  }
}