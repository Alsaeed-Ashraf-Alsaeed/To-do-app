import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/buisness_logic_layer/task_bloc/task_states.dart';
import 'package:todo_app/ui_layer/screens/add_task_screen.dart';
import 'package:todo_app/ui_layer/screens/home_screen.dart';
import 'package:todo_app/ui_layer/screens/notification_screen.dart';

import '../buisness_logic_layer/task_bloc/task_cubit.dart';
import '../buisness_logic_layer/theme/theme_cubit.dart';
import '../main.dart';

bool wasLight(context) =>
    BlocProvider.of<ThemeCubit>(context).state.themeMode == ThemeMode.light;

bool wasPortrait(context) =>
    MediaQuery.of(context).orientation == Orientation.portrait;

class MyRouter {

  Route onRouteGenerate(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (context) => HomeScreen(key: homeScreenKey),
        );
      case '/AddTaskScreen':
        return PageRouteBuilder(
          pageBuilder: (ctx, ani1, ani2) => const AddTasksScreen(),
          transitionsBuilder: (ctx, ani1, ani2, widget) => FadeTransition(
            opacity: ani1,
            child: widget,
          ),
          transitionDuration: Duration(milliseconds: 400),
        );
      case '/NS':
        return MaterialPageRoute(
          builder: (context) => NotificationScreen(
            key: nSKey, date: '', description: '', title: '',),
        );
      default:
        return MaterialPageRoute(
          builder: (ctx) => HomeScreen(key: const Key('')),
        );
    }
  }
}
