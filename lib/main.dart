import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_app/buisness_logic_layer/task_bloc/task_cubit.dart';
import 'package:todo_app/buisness_logic_layer/theme/theme_cubit.dart';
import 'package:todo_app/buisness_logic_layer/theme/theme_states.dart';
import 'package:todo_app/constatns/colors.dart';
import 'package:todo_app/shared/methods.dart';
import 'package:todo_app/ui_layer/screens/home_screen.dart';
import 'package:todo_app/ui_layer/screens/notification_screen.dart';
import 'package:todo_app/ui_layer/widgets/themes.dart';


void main() {
  runApp( MyApp());
}
final GlobalKey<NavigatorState> homeScreenKey = GlobalKey(debugLabel: 's1');
final GlobalKey<NavigatorState> nSKey = GlobalKey(debugLabel: 's2');
class MyApp extends StatelessWidget {
   MyApp({super.key});
  MyRouter myRouter =MyRouter();

  @override
  Widget build(BuildContext context) {
    print('MyApp rebuilt');
    return BlocProvider<ThemeCubit>(
      create: (ctx) => ThemeCubit(),
      child: BlocProvider<TasksCubit>(
        create: (ctx)=>TasksCubit()..resetAllRepeatedNotification(),
        child: ScreenUtilInit(
          designSize: Size(400, 800),
          builder: (context, widget) {
            return BlocSelector<ThemeCubit, ThemeStates, ThemeMode>(
              selector: (states) => states.themeMode,
              builder: (ctx, widget) => MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'To Do',
                onGenerateRoute:myRouter.onRouteGenerate ,
                theme: MyTheme.lightTheme,
                darkTheme: MyTheme.darkTheme,
                themeMode: BlocProvider.of<ThemeCubit>(context).state.themeMode ==
                        ThemeMode.light
                    ? ThemeMode.light
                    : ThemeMode.dark,
              ),
            );
          },
        ),
      ),
    );
  }
}

