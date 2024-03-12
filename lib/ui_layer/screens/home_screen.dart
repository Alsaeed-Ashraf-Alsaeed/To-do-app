import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/buisness_logic_layer/task_bloc/task_states.dart';
import 'package:todo_app/data_layer/sqflite_db/sqflite_db.dart';

import 'package:todo_app/shared/methods.dart';
import 'package:todo_app/ui_layer/screens/notification_screen.dart';
import 'package:todo_app/ui_layer/widgets/themes.dart';
import '../../buisness_logic_layer/task_bloc/task_cubit.dart';
import '../../buisness_logic_layer/theme/theme_cubit.dart';
import '../../services/local_notifications.dart';
import '../../data_layer/models/task_model.dart';
import '../widgets/custom_button.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({required Key key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late MyLocalDatabase myLocalDataBase;
   late List<Task> tasks;
  DateTime selectedDate = DateTime.now();

  late MyNotifications myNotifications;

  @override
  void initState() {

    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..forward();
    myNotifications = MyNotifications()
      ..requestPermission()
      ..initialize();
    super.initState();
    myLocalDataBase = MyLocalDatabase();
    myLocalDataBase.initializeDB();
    tasks = BlocProvider.of<TasksCubit>(context).tasks;
  }

  @override
  Widget build(BuildContext context) {
    print('home-screen built');

    return Scaffold(
      appBar: AppBar(
        toolbarHeight:
            MediaQuery.of(context).orientation == Orientation.portrait
                ? 50.h
                : 40,
        title: Row(
          children: [
            TextButton(
              child: const Text(
                'insert',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                Navigator.of(context).pushNamed('/NS');
              },
            ),
            TextButton(
                child: const Text(
                  'read',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                }),
          ],
        ),
        actions: [
          Center(
            child: Text(
              wasLight(context) ? 'Light mode' : 'Dark mode',
              textAlign: TextAlign.justify,
            ),
          ),
          IconButton(
              onPressed: () {
                BlocProvider.of<ThemeCubit>(context).changeTheme();
              },
              icon: Icon(
                wasLight(context) ? Icons.wb_sunny_outlined : Icons.dark_mode,
                size: 30.r,
              ))
        ],
      ),
      body: SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildTaskBar(context),
            buildDateBar(context),
            Divider(
              thickness: 2,
              height: 15,
              color: wasLight(context) ? Colors.black45 : Colors.white30,
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Text(
                  'Tasks',
                  style: MyTheme.buildTextStyle1(context),
                ),
                Expanded(child: SizedBox()),
                SizedBox(
                  width: 150.w,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: wasLight(context)
                            ? Colors.redAccent.withOpacity(0.9)
                            : Colors.black54),
                    onPressed: () {
                     BlocProvider.of<TasksCubit>(context).deleteAllTasksAndNotification();
                    },
                    child: Text('Delete all Tasks ☠'
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            buildTasksbody(context),
          ],
        ),
      ),
    );
  }

  buildTaskBar(context) {
    return SizedBox(
      height: 120.h,
      child: Row(
        children: [
          Text('${DateFormat('MMMM ,dd \nyyyy').format(DateTime.now())}',
              style: MyTheme.buildTextStyle1(context)),
          Expanded(
            flex: 1,
            child: SizedBox(
              width: 2.w,
            ),
          ),
           TaskButton(),
        ],
      ),
    );
  }

  Widget buildDateBar(context) {
    return SizedBox(
      child: DatePicker(
        DateTime.now(),
        width: 70,
        dateTextStyle: TextStyle(
          fontSize: 20.h,
          color: wasLight(context) ? Colors.black : Colors.white,
        ),
        dayTextStyle: TextStyle(
          fontSize: 12.h,
          color: wasLight(context) ? Colors.black : Colors.white,
        ),
        monthTextStyle: TextStyle(
          fontSize: 13.h,
          color: wasLight(context) ? Colors.black : Colors.white,
        ),
        selectedTextColor: !wasLight(context) ? Colors.black : Colors.white,
        initialSelectedDate: selectedDate,
        selectionColor:
            wasLight(context) ? Colors.teal.withOpacity(0.7) : Colors.white30,
        onDateChange: (selected) {
          selectedDate = selected;
          BlocProvider.of<TasksCubit>(context).onDateChange(selected);
        },
      ),
    );
  }

  Widget buildTasksbody(context) {
    return BlocBuilder<TasksCubit, TasksStates>(builder: (context, state) {
      if (state is TasksInitialState) {
        return const CircularProgressIndicator();
      } else {
        if (state.tasks!.isNotEmpty) {
          return Expanded(
            child: ListView.builder(
              itemCount: state.tasks!.length,
              scrollDirection:
                  wasPortrait(context) ? Axis.vertical : Axis.horizontal,
              itemBuilder: (ctx, idx) => AnimationConfiguration.staggeredList(
                position: idx,
                duration: const Duration(milliseconds: 900),
                child: SlideAnimation(
                  horizontalOffset: 50.0,
                  child: FadeInAnimation(
                    child: GestureDetector(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>NotificationScreen(
                          key: Key('NS$idx'),
                          title: state.tasks![idx].title,
                          date: state.tasks![idx].date.toString(),
                          description: state.tasks![idx].description.toString(),

                        )));
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            // for designing but it will be removed
                            width: wasPortrait(context) ? 360.w : 360,
                            decoration: BoxDecoration(
                              color: wasLight(context)
                                  ? Colors.teal.withOpacity(0.6)
                                  : Colors.black26,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(14),
                                bottomLeft: Radius.circular(14),
                                topRight: Radius.circular(14),
                                bottomRight: Radius.circular(14),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.accessibility_sharp,
                                      size: 20.h,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      state.tasks![idx].title,
                                      style: MyTheme.buildTextStyle2(context),
                                    ),
                                    const Expanded(child: SizedBox()),
                                    CircleAvatar(
                                        backgroundColor: wasLight(context)
                                            ? Colors.teal
                                            : Colors.black87,
                                        child: Text(
                                          state.tasks![idx].taskId.toString(),
                                          style:
                                              MyTheme.buildTextStyle2(context),
                                        )),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.alarm,
                                      size: 20.h,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      'starts ${state.tasks![idx].startTime} ${state!.tasks![idx].dayPeriod} ',
                                      style: MyTheme.buildTextStyle3(context),
                                    ),
                                    Container(
                                        height: 20.h,
                                        child: VerticalDivider(
                                          color: Colors.white70,
                                          thickness: 2,
                                          width: 10.w,
                                        )),
                                    Text(
                                      'ends ${state.tasks![idx].endTime}',
                                      style: MyTheme.buildTextStyle3(context),
                                    ),
                                  ],
                                ),
                                const Divider(
                                  color: Colors.white54,
                                  thickness: 2,
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.description,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      'description',
                                      style: MyTheme.buildTextStyle2(context),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  state.tasks![idx].description,
                                  style: MyTheme.buildTextStyle3(context),
                                ),
                                const Divider(
                                  color: Colors.white54,
                                  thickness: 2,
                                ),
                                buildTaskBottomButtons(
                                    state.tasks![idx].wasCompleted, idx, state),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 17.h,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        } else {
          return Center(
            child: Text(
              'No tasks Now ....',
              style: MyTheme.buildTextStyle1(context),
            ),
          );
        }
      }
    });
  }

  Row buildTaskBottomButtons(String wasCompleted, int idx, TasksStates state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(state.tasks![idx].repeat,style: MyTheme.buildTextStyle3(context),),
        SizedBox(width: 10,),
        wasCompleted == 'true'
            ? SizedBox(
                width: wasPortrait(context) ? 100.w : 60.w,
                height: 30.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: wasLight(context)
                          ? Colors.teal.shade500
                          : Colors.black54),
                  onPressed: () {
                    BlocProvider.of<TasksCubit>(context)
                        .completeTask('false', idx,selectedDate);
                  },
                  child: Icon(
                    Icons.done,
                    size: 30.r,
                  ),
                ),
              )
            : SizedBox(
                width: wasPortrait(context) ? 100.w : 60.w,
                height: 30.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: wasLight(context)
                          ? Colors.teal.shade500
                          : Colors.black54),
                  onPressed: () {
                    BlocProvider.of<TasksCubit>(context)
                        .completeTask('true', idx,selectedDate);
                  },
                  child: Text(
                    'Task Completed',
                    style: MyTheme.buildTextStyle4(context),
                  ),
                ),
              ),
        SizedBox(
          width: 15.w,
        ),
        SizedBox(
          width: wasPortrait(context) ? 100.w : 50.w,
          height: 30.h,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor:
                    wasLight(context) ? Colors.redAccent.withOpacity(0.6) : Colors.redAccent.withOpacity(0.5)),
            onPressed: () {
              BlocProvider.of<TasksCubit>(context).deleteTasks(idx: idx,date: selectedDate);
            },
            child: Text(
              'Delete Task',
              style: MyTheme.buildTextStyle4(context),
            ),
          ),
        ),
      ],
    );
  }

  void buildTaskBottomSheet(
    String title,
    bool wasCompleted,
  ) {
    showModalBottomSheet(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        barrierColor: Colors.white.withOpacity(0),
        elevation: 0,
        useSafeArea: true,
        context: context,
        builder: (context) {
          return Container(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            decoration: BoxDecoration(
              color: wasLight(context)
                  ? Colors.teal.withOpacity(0.5)
                  : Colors.black54,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            height: 250.h,
            width: double.infinity,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: MyTheme.buildTextStyle1(context).copyWith(),
                ),
                ElevatedButton(
                    onPressed: () {}, child: const Text('Complete Task ')),
                ElevatedButton(
                    onPressed: () {}, child: const Text('cancel Task ')),
                ElevatedButton(
                    onPressed: () {}, child: const Text('Complete Task ')),
              ],
            ),
          );
        });
  }
}
