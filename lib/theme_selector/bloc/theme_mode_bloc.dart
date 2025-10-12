import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'theme_mode_event.dart';

class ThemeModeBloc extends HydratedBloc<ThemeModeEvent, ThemeMode> {
  ThemeModeBloc() : super(ThemeMode.system) {
    on<ThemeModeChanged>(_onThemeModeChanged);
  }

  void _onThemeModeChanged(
    ThemeModeChanged event,
    Emitter<ThemeMode> emit,
  ) {
    emit(event.themeMode ?? state);
  }

  @override
  ThemeMode? fromJson(Map<String, dynamic> json) {
    return ThemeMode.values.firstWhere(
      (e) => e.name == json['theme_mode'],
      orElse: () => ThemeMode.system,
    );
  }

  @override
  Map<String, dynamic>? toJson(ThemeMode state) {
    return {'theme_mode': state.name};
  }
}
