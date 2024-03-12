import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/shared/methods.dart';
import '../../buisness_logic_layer/task_bloc/task_cubit.dart';
import '../../data_layer/models/task_model.dart';
import '../widgets/input_field.dart';
import '../widgets/themes.dart';

class AddTasksScreen extends StatefulWidget {
  const AddTasksScreen({Key? key}) : super(key: key);

  @override
  State<AddTasksScreen> createState() => _AddTasksScreenState();
}

class _AddTasksScreenState extends State<AddTasksScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  DateTime taskDate = DateTime.now();
  String startTime = DateFormat('hh:mm a')
      .format(DateTime.now().add(const Duration(seconds: 5)));
  String endTime = DateFormat('hh:mm a')
      .format(DateTime.now().add(const Duration(minutes: 15)));
  String dayPeriod = 'am';
  int selectedReminder = 5;
  List<int> reminders = [0, 5, 10, 15, 20];
  List<String> repeats = ['none', 'daily', 'weekly', 'monthly'];
  String selectedRepeat = 'daily';
  late List<Task> tasks;

  @override
  void initState() {
    tasks = BlocProvider.of<TasksCubit>(context).state.tasks!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        toolbarHeight: 45.h,
        actions: [
          CircleAvatar(
            radius: 20.r,
            backgroundColor: wasLight(context) ? Colors.teal : Colors.black54,
            child: const Icon(
              Icons.person,
              size: 30,
            ),
          )
        ],
        centerTitle: true,
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(10),
        child: SizedBox(
          width: 380.w,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  'Title',
                  style: MyTheme.buildTextStyle1(context),
                ),
                const SizedBox(
                  height: 10,
                ),
                InputField(
                  hint: 'Add task title',
                  inputFieldController: titleController,
                  suffix: Icon(
                    Icons.add_task,
                    size: 30.r,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'description',
                  style: MyTheme.buildTextStyle1(context),
                ),
                const SizedBox(
                  height: 10,
                ),
                InputField(
                  hint: 'Add description',
                  inputFieldController: descriptionController,
                  suffix: Icon(
                    Icons.description,
                    size: 30.r,
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  'Date',
                  style: MyTheme.buildTextStyle1(context),
                ),
                const SizedBox(
                  height: 5,
                ),
                GestureDetector(
                  onTap: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2023),
                      lastDate: DateTime(2025),
                    ).then((value) {
                      setState(() {
                        taskDate = value ?? DateTime.now();
                      });
                      print(taskDate);
                    });
                  },
                  child: InputField(
                    hint: DateFormat('yyyy/MM/dd').format(taskDate),
                    inputFieldController: dateController,
                    suffix: Icon(
                      Icons.date_range,
                      size: 30.r,
                    ),
                    enabled: false,
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Start time',
                          style: MyTheme.buildTextStyle1(context),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        GestureDetector(
                          onTap: () async {
                            TimeOfDay? x = await showTimePicker(
                              context: context,
                              initialTime: const TimeOfDay(
                                hour: 12,
                                minute: 00,
                              ),
                            );
                            startTime =
                                '${x!.hour.toString().length == 1 ? '0${x.hour}' : '${x.hour}'}:${x.minute.toString().length == 1 ? '0${x.minute}' : '${x.minute}'}';
                            dayPeriod = x.period == DayPeriod.am ? 'am' : 'pm';

                            setState(() {});
                            print(startTime);
                          },
                          child: InputField(
                            width: 180.w,
                            hint: startTime,
                            inputFieldController: null,
                            suffix: Icon(
                              Icons.timelapse,
                              size: 30.r,
                            ),
                            enabled: false,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 15.w,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'End time',
                          style: MyTheme.buildTextStyle1(context),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        GestureDetector(
                          onTap: () async {
                            TimeOfDay? x = await showTimePicker(
                              context: context,
                              initialTime: const TimeOfDay(
                                hour: 10,
                                minute: 00,
                              ),
                            );
                            endTime =
                                '${x!.hour.toString().length == 1 ? '0${x.hour}' : '${x.hour}'}:${x.minute.toString().length == 1 ? '0${x.minute}' : '${x.minute}'}';

                            setState(() {});
                            print(startTime);
                          },
                          child: InputField(
                            enabled: false,
                            width: 180.w,
                            hint: endTime,
                            inputFieldController: null,
                            suffix: Icon(
                              Icons.access_alarms_sharp,
                              size: 30.r,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  'Reminder',
                  style: MyTheme.buildTextStyle1(context),
                ),
                const SizedBox(
                  height: 5,
                ),
                InputField(
                  hint: 'remind me $selectedReminder minutes earlier',
                  inputFieldController: null,
                  enabled: true,
                  suffix: DropdownButton(
                    borderRadius: BorderRadius.circular(20),
                    onChanged: (selected) {
                      setState(() {
                        selectedReminder = selected!;
                      });
                    },
                    icon: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 40.r,
                      color: wasLight(context) ? Colors.teal : Colors.white,
                    ),
                    items: reminders
                        .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(
                              '$e minutes early',
                            )))
                        .toList(),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  'Repeat',
                  style: MyTheme.buildTextStyle1(context),
                ),
                SizedBox(
                  height: 5.h,
                ),
                InputField(
                  onFieldSubmitted: (txt) {
                    selectedRepeat = txt;
                  },
                  hint: selectedRepeat,
                  inputFieldController: null,
                  suffix: DropdownButton(
                    borderRadius: BorderRadius.circular(20.r),
                    onChanged: (selected) {
                      setState(() {
                        selectedRepeat = selected ?? 'daily';
                      });
                    },
                    items: repeats
                        .map((e) => DropdownMenuItem(
                            value: e, child: Text(e.toString())))
                        .toList(),
                    icon: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 40.sp,
                      color: wasLight(context) ? Colors.teal : Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Container(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  width: 380.w,
                  height: 50.h,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(15)),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          wasLight(context) ? Colors.teal : Colors.black45,
                    ),
                    onPressed: () {
                      BlocProvider.of<TasksCubit>(context).addTasks(
                        task: Task(
                          taskId: tasks.isEmpty ? 1 : tasks.last.taskId + 1,
                          title: titleController.text,
                          description: descriptionController.text,
                          date: taskDate,
                          startTime: startTime.substring(0, 5),
                          endTime: endTime.substring(0, 5),
                          repeat: selectedRepeat,
                          remind: selectedReminder,
                          wasCompleted: 'false',
                          dayPeriod: dayPeriod,
                        ),
                      );

                      Navigator.pop(context);
                    },
                    child: Text(
                      'Add Task',
                      style: TextStyle(fontSize: 25.spMin),
                    ),
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
