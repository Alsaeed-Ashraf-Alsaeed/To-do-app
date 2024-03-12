import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/buisness_logic_layer/task_bloc/task_states.dart';
import 'package:todo_app/data_layer/sqflite_db/sqflite_db.dart';
import 'package:todo_app/services/local_notifications.dart';
import '../../data_layer/models/task_model.dart';
import 'package:timezone/timezone.dart' as tz;

class TasksCubit extends Cubit<TasksStates> {
  MyNotifications myNotifications = MyNotifications();
  MyLocalDatabase myLocalDatabase = MyLocalDatabase();
  List<Task> tasks = [];

  TasksCubit() : super(TasksInitialState()) {
    initiateDBTasks();
  }

  void initiateDBTasks() async {
    List<Map> dBData = await (await myLocalDatabase.initDB)!.query('tasks');

    tasks = dBData.map((e) => Task.fromJson(e)).toList();
    emit(TasksStates(tasks: tasksByDate(DateTime.now())));
  }

  Future<void> addTasks({required Task task}) async {
    tasks.add(task);
    (await myLocalDatabase.initDB!)!.insert('tasks', task.toJson());
    String start =
        '${DateFormat('yyyy-MM-dd').format(task.date)} ${task
        .startTime}:00.000';

    //////////////////////

    myNotifications.showScheduledNotification(
        id: task.taskId,
        title: task.title,
        body: task.description,
        taskDate:
        DateTime.parse(start).subtract(Duration(minutes: task.remind)),
        repeat: task.repeat);

    emit(TasksStates(tasks: tasksByDate(DateTime.now())));
  }

  Future<void> deleteTasks({required int idx, required DateTime date}) async {
    int dBInt = await (await myLocalDatabase.initDB)!
        .delete('tasks', where: 'taskID=${tasks[idx].taskId}');

    ////////////////////////////////////////////////
    myNotifications.cancelNotification(tasks[idx].taskId);
    tasks.removeAt(idx);

    emit(TasksStates(tasks: tasksByDate(date)));
  }

  void completeTask(String wasCompleted, idx, DateTime date) async {
    int dBData = await (await myLocalDatabase.initDB)!.update(
        'tasks', {'wasCompleted': '$wasCompleted'},
        where: 'taskID=${tasks[idx].taskId}');
    tasks[idx].wasCompleted = wasCompleted;
    emit(TasksStates(tasks: tasksByDate(date)));
  }

////////
  void onDateChange(DateTime date) {
    emit(TasksStates(tasks: tasksByDate(date)));
  }
//////
  List<Task> tasksByDate(DateTime date) {

    List<Task> onChangeTasks = tasks.where((task) {
      int difference = (date
          .difference(task.date)
          .inDays);
      return task.date.toString().substring(0, 10) ==
          date.toString().substring(0, 10) ||
          task.repeat == 'daily' ||
          (task.repeat == 'weekly' &&
              (difference.abs() % 7) == 0) ||
          (task.repeat == 'monthly' && date.day == task.date.day);
    }).toList();
    return onChangeTasks;
  }



  void deleteAllTasksAndNotification() async {
    myNotifications.notificationsPlugin.cancelAll();
    (await myLocalDatabase.initDB)!.delete('tasks');
    tasks.removeRange(0, tasks.length);
    emit(TasksStates(tasks: tasks));
  }


  Future<void> resetAllRepeatedNotification() async {
    myNotifications.notificationsPlugin.cancelAll();
    tasks =( await(await myLocalDatabase.initDB)!.query('tasks'))
        .map((e) => Task.fromJson(e))
        .toList();
    for (Task task in tasks) {
      String start =
          '${DateFormat('yyyy-MM-dd').format(task.date)} ${task
          .startTime}:00.000';
      myNotifications.showScheduledNotification(
          id: task.taskId,
          title: task.title,
          body: task.description,
          taskDate: DateTime.parse(start).subtract(
        Duration(minutes: task.remind)),
        repeat: task.repeat,

      );
    }
  }
}
