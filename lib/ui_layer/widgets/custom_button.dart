import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/buisness_logic_layer/task_bloc/task_states.dart';
import 'package:todo_app/buisness_logic_layer/theme/theme_cubit.dart';
import 'package:todo_app/constatns/colors.dart';

import '../../buisness_logic_layer/task_bloc/task_cubit.dart';
import '../../shared/methods.dart';


class TaskButton extends StatelessWidget {
  const TaskButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('custom buttom built');
    return Container(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          width: 1.w,
          color: wasLight(context) ? Colors.tealAccent : Colors.white30,
        ),
      ),
      height: 50.h,
      width: 180.w,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(wasLight(context)
              ? Colors.teal.withOpacity(0.6)
              : Colors.black54,),
        ),
        child: Text('Add Task', style: GoogleFonts.acme(
          fontSize: 28.h,
          color: Colors.white,
        ),),
        onPressed: () {
           Navigator.of(context).pushNamed('/AddTaskScreen');
        },
      ),


    );
  }
}
