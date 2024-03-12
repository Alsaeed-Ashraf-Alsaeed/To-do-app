
import 'package:todo_app/data_layer/models/task_model.dart';
class TasksStates {
  TasksStates({this.tasks});

  List<Task>? tasks = [

  ];
}

class TasksInitialState extends TasksStates{}
