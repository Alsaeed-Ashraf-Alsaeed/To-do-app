class Task {
  int taskId;

  String title;
  String description;
  DateTime date;
  String startTime;
  String endTime;
  String? dayPeriod;
  String repeat;
  String wasCompleted;
  int remind;

  Task({
    required this.taskId,
    required this.title,
    required this.description,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.dayPeriod,
    required this.repeat,
    required this.remind,
    required this.wasCompleted,

  });


  Map<String, Object?> toJson() {
    return {
      'taskID': taskId,
      'title': title,
      'description': description,
      'date': date.toString(),
      'startTime': startTime,
      'endTime': endTime,
// no bool in the sql so we have to turn it to string
      'wasCompleted': wasCompleted,
      'repeat': repeat,
      'remind': remind,
      'dayPeriod': dayPeriod,
    };
  }

  factory Task.fromJson(Map row){
    return Task(
        taskId: row['taskID'],
        title: row['title'],
        description: row['description'],
        date: DateTime.parse(row['date']),
        startTime: row['startTime'],
        endTime: row['endTime'],
        dayPeriod: row['dayPeriod'],
        repeat: row['repeat'],
        remind: row['remind'],
        wasCompleted: row['wasCompleted']);
  }

}

