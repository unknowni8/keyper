import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keyper/app/routes/routes.dart';
import 'package:keyper/l10n/l10n.dart';
import 'package:keyper/theme_selector/bloc/theme_mode_bloc.dart';
import 'package:keyper/profile/bloc/locale_cubit.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeModeBloc>(create: (_) => ThemeModeBloc()),
        BlocProvider<LocaleCubit>(create: (_) => LocaleCubit()),
      ],
      child: const AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ThemeModeBloc>().state;
    final locale = context.watch<LocaleCubit>().state;
    return MaterialApp.router(
      themeMode: themeMode,
      theme: const AppTheme().themeData,
      darkTheme: const AppDarkTheme().themeData,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: locale,
      routerConfig: router,
    );
  }
}
