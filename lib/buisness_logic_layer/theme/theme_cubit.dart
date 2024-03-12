import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:todo_app/buisness_logic_layer/theme/theme_states.dart';

class ThemeCubit extends Cubit<ThemeStates> {
  ThemeCubit() : super(ThemeStates(themeMode: ThemeMode.light));

  void changeTheme(){
    state.themeMode==ThemeMode.light?
        emit(ThemeStates(themeMode: ThemeMode.dark)):
        emit(ThemeStates(themeMode: ThemeMode.light));

  }

}
