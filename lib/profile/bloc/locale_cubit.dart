import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:flutter/material.dart';

class LocaleCubit extends HydratedCubit<Locale> {
  LocaleCubit() : super(const Locale('en'));

  void setLocale(Locale locale) => emit(locale);

  @override
  Locale? fromJson(Map<String, dynamic>? json) {
    final code = json?['languageCode'] as String?;
    if (code == null || code.isEmpty) return const Locale('en');
    return Locale(code);
  }

  @override
  Map<String, dynamic>? toJson(Locale state) => {
        'languageCode': state.languageCode,
      };
}