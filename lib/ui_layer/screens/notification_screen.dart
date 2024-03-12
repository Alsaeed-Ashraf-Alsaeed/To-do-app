import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_app/buisness_logic_layer/theme/theme_cubit.dart';
import 'package:todo_app/constatns/colors.dart';
import 'package:todo_app/ui_layer/widgets/themes.dart';

class NotificationScreen extends StatelessWidget {
  String title;

  String description;

  String date;

  NotificationScreen(
      {Key? key,
      required this.date,
      required this.description,
      required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('NotificationScreen rebuilt');
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50.h,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 30.sp,
          ),
          onPressed: () {
            Navigator.of(context).canPop() == true
                ? Navigator.of(context).pop()
                : null;
          },
        ),
      ),
      body: SafeArea(
        minimum: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AnimatedDefaultTextStyle(
                style: MyTheme.buildTextStyle1(context),
                duration: const Duration(milliseconds: 700),
                child: const Text('Hey , ready?  '),
              ),
              AnimatedDefaultTextStyle(
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w500,
                  color: BlocProvider.of<ThemeCubit>(context).state.themeMode ==
                          ThemeMode.light
                      ? appBarColor
                      : Colors.white,
                ),
                duration: const Duration(milliseconds: 700),
                child: const Text('Here is some New Notifications !!!! '),
              ),
              SizedBox(
                height: 20.h,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: BlocProvider.of<ThemeCubit>(context).state.themeMode ==
                          ThemeMode.light
                      ? nearSilver
                      : Colors.black38,
                ),
                height: 570.h,
                width: 350.h,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                       const SizedBox(
                        height: 15,
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.access_alarms_sharp,
                          size: 30.sp,
                          color: Colors.white,
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:  [
                            const Text(
                              'Title',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              title,
                              style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                       const SizedBox(
                        height: 7,
                      ),
                       const Divider(
                        thickness: 1,
                        color: Colors.white54,
                      ),
                       const SizedBox(
                        height: 5,
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.description,
                          size: 30.sp,
                          color: Colors.white,
                        ),
                        title: Row(
                          children: const [
                            Text(
                              'Description',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        subtitle:  Text(
                          description,
                          style: const TextStyle(fontSize: 20, color: Colors.white70),
                        ),
                      ),
                       const Divider(
                        thickness: 2,
                        color: Colors.white30,
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.date_range,
                          size: 30.sp,
                          color: Colors.white,
                        ),
                        title: Row(
                          children: [
                             const Text(
                              'Date',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                            Container(
                              height: 30.h,
                              child: const VerticalDivider(
                                color: Colors.white54,
                                thickness: 2,
                                width: 20,
                              ),
                            ),
                             Text(
                             date==''?'':date.substring(0,16),
                              style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
