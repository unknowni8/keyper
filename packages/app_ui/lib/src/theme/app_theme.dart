import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// {@template app_theme}
/// The Default App [ThemeData].
/// {@endtemplate}
class AppTheme {
  /// {@macro app_theme}
  const AppTheme();

  /// Default `ThemeData` for App UI.
  ThemeData get themeData {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.blue,
      canvasColor: _backgroundColor,
      scaffoldBackgroundColor: _backgroundColor,
      iconTheme: _iconTheme,
      appBarTheme: _appBarTheme,
      dividerTheme: _dividerTheme,
      textTheme: _textTheme,
      inputDecorationTheme: _inputDecorationTheme,
      buttonTheme: _buttonTheme,
      splashColor: AppColors.transparent,
      snackBarTheme: _snackBarTheme,
      elevatedButtonTheme: _elevatedButtonTheme,
      textButtonTheme: _textButtonTheme,
      colorScheme: _colorScheme,
      bottomSheetTheme: _bottomSheetTheme,
      listTileTheme: _listTileTheme,
      switchTheme: _switchTheme,
      progressIndicatorTheme: _progressIndicatorTheme,
      tabBarTheme: _tabBarTheme,
      bottomNavigationBarTheme: _bottomNavigationBarTheme,
      chipTheme: _chipTheme,
    );
  }

  ColorScheme get _colorScheme {
    return ColorScheme.light(
      primary: AppColors.blue,
      secondary: AppColors.secondary,
      surface: _backgroundColor,
      // background removed: use surface instead
      // onBackground removed: use onSurface instead
      onPrimary: AppColors.white,
      onSecondary: AppColors.white,
      onSurface: AppColors.onBackground,
      outline: AppColors.outlineLight,
    );
  }

  SnackBarThemeData get _snackBarTheme {
    return SnackBarThemeData(
      contentTextStyle: UITextStyle.bodyText1.copyWith(color: AppColors.white),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.sm),
      ),
      actionTextColor: AppColors.lightBlue.shade300,
      backgroundColor: AppColors.black,
      elevation: 4,
      behavior: SnackBarBehavior.floating,
    );
  }

  Color get _backgroundColor => AppColors.white;

  AppBarTheme get _appBarTheme {
    return AppBarTheme(
      iconTheme: _iconTheme,
      titleTextStyle: _textTheme.titleLarge,
      elevation: 0,
      toolbarHeight: 64,
      backgroundColor: AppColors.transparent,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );
  }

  IconThemeData get _iconTheme {
    return const IconThemeData(color: AppColors.onBackground);
  }

  DividerThemeData get _dividerTheme {
    return const DividerThemeData(
      color: AppColors.outlineLight,
      space: AppSpacing.xlg,
      thickness: AppSpacing.xxxs,
    );
  }

  TextTheme get _textTheme => uiTextTheme;

  /// The Content text theme based on [ContentTextStyle].
  static final contentTextTheme =
      TextTheme(
        displayLarge: ContentTextStyle.headline1,
        displayMedium: ContentTextStyle.headline2,
        displaySmall: ContentTextStyle.headline3,
        headlineMedium: ContentTextStyle.headline4,
        headlineSmall: ContentTextStyle.headline5,
        titleLarge: ContentTextStyle.headline6,
        titleMedium: ContentTextStyle.subtitle1,
        titleSmall: ContentTextStyle.subtitle2,
        bodyLarge: ContentTextStyle.bodyText1,
        bodyMedium: ContentTextStyle.bodyText2,
        labelLarge: ContentTextStyle.button,
        bodySmall: ContentTextStyle.caption,
        labelSmall: ContentTextStyle.overline,
      ).apply(
        bodyColor: AppColors.onBackground,
        displayColor: AppColors.onBackground,
        decorationColor: AppColors.onBackground,
      );

  /// The UI text theme based on [UITextStyle].
  static final uiTextTheme =
      TextTheme(
        displayLarge: UITextStyle.headline1,
        displayMedium: UITextStyle.headline2,
        displaySmall: UITextStyle.headline3,
        headlineMedium: UITextStyle.headline4,
        headlineSmall: UITextStyle.headline5,
        titleLarge: UITextStyle.headline6,
        titleMedium: UITextStyle.subtitle1,
        titleSmall: UITextStyle.subtitle2,
        bodyLarge: UITextStyle.bodyText1,
        bodyMedium: UITextStyle.bodyText2,
        labelLarge: UITextStyle.button,
        bodySmall: UITextStyle.caption,
        labelSmall: UITextStyle.overline,
      ).apply(
        bodyColor: AppColors.onBackground,
        displayColor: AppColors.onBackground,
        decorationColor: AppColors.onBackground,
      );

  InputDecorationTheme get _inputDecorationTheme {
    return InputDecorationTheme(
      suffixIconColor: AppColors.mediumEmphasisSurface,
      prefixIconColor: AppColors.mediumEmphasisSurface,
      hoverColor: AppColors.inputHover,
      focusColor: AppColors.inputFocused,
      fillColor: AppColors.inputEnabled,
      enabledBorder: _textFieldBorder,
      focusedBorder: _textFieldBorder,
      disabledBorder: _textFieldBorder,
      hintStyle: UITextStyle.bodyText1.copyWith(
        color: AppColors.mediumEmphasisSurface,
      ),
      contentPadding: const EdgeInsets.all(AppSpacing.lg),
      border: const UnderlineInputBorder(),
      filled: true,
      isDense: true,
      errorStyle: UITextStyle.caption,
    );
  }

  ButtonThemeData get _buttonTheme {
    return ButtonThemeData(
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.sm),
      ),
    );
  }

  ElevatedButtonThemeData get _elevatedButtonTheme {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
        textStyle: _textTheme.labelLarge,
        backgroundColor: AppColors.blue,
      ),
    );
  }

  TextButtonThemeData get _textButtonTheme {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        textStyle: _textTheme.labelLarge?.copyWith(
          fontWeight: AppFontWeight.light,
        ),
        foregroundColor: AppColors.black,
      ),
    );
  }

  BottomSheetThemeData get _bottomSheetTheme {
    return const BottomSheetThemeData(
      backgroundColor: AppColors.modalBackground,
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppSpacing.lg),
          topRight: Radius.circular(AppSpacing.lg),
        ),
      ),
    );
  }

  ListTileThemeData get _listTileTheme {
    return ListTileThemeData(
      iconColor: AppColors.onBackground,
      contentPadding: EdgeInsets.all(AppSpacing.lg),
    );
  }

  SwitchThemeData get _switchTheme {
    return SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.darkAqua;
        }
        return AppColors.eerieBlack;
      }),
      trackColor: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primaryContainer;
        }
        return AppColors.grey;
      }),
      trackOutlineColor: WidgetStateProperty.resolveWith((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primaryContainer;
        }
        return AppColors.grey;
      }),
    );
  }

  ProgressIndicatorThemeData get _progressIndicatorTheme {
    return const ProgressIndicatorThemeData(
      color: AppColors.darkAqua,
      circularTrackColor: AppColors.borderOutline,
    );
  }

  TabBarThemeData get _tabBarTheme {
    return TabBarThemeData(
      labelStyle: UITextStyle.button,
      labelColor: AppColors.darkAqua,
      labelPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md + AppSpacing.xxs,
      ),
      unselectedLabelStyle: UITextStyle.button,
      unselectedLabelColor: AppColors.mediumEmphasisSurface,
      indicator: const UnderlineTabIndicator(
        borderSide: BorderSide(width: 3, color: AppColors.darkAqua),
      ),
      indicatorSize: TabBarIndicatorSize.label,
    );
  }

  BottomNavigationBarThemeData get _bottomNavigationBarTheme {
    return BottomNavigationBarThemeData(
      backgroundColor: AppColors.background,
      selectedItemColor: AppColors.darkAqua,
      unselectedItemColor: AppColors.onSurfaceLight.withValues(alpha: 0.74),
    );
  }

  InputBorder get _textFieldBorder => const UnderlineInputBorder(
    borderSide: BorderSide(width: 1.5, color: AppColors.darkAqua),
  );

  ChipThemeData get _chipTheme {
    return const ChipThemeData(backgroundColor: AppColors.primaryContainer);
  }
}

/// {@template app_dark_theme}
/// Dark Mode App [ThemeData].
/// {@endtemplate}
class AppDarkTheme extends AppTheme {
  /// {@macro app_dark_theme}
  const AppDarkTheme();

  @override
  ThemeData get themeData => ThemeData.dark().copyWith(
    brightness: Brightness.dark,
    colorScheme: _colorScheme,
    textTheme: _textTheme,
    bottomSheetTheme: _bottomSheetTheme,
    chipTheme: _chipTheme,
    listTileTheme: _listTileTheme,
    switchTheme: _switchTheme,
    progressIndicatorTheme: _progressIndicatorTheme,
    tabBarTheme: _tabBarTheme,
    bottomNavigationBarTheme: _bottomNavigationBarTheme,
    buttonTheme: _buttonTheme,
    elevatedButtonTheme: _elevatedButtonTheme,
    textButtonTheme: _textButtonTheme,
    dividerTheme: _dividerTheme,
  );

  @override
  ColorScheme get _colorScheme {
    return const ColorScheme.dark().copyWith(
      primary: AppColors.blue,
      secondary: AppColors.secondary,
      surface: AppColors.surfaceDark,
      // background removed: use surface instead
      onPrimary: AppColors.white,
      onSecondary: AppColors.white,
      onSurface: AppColors.onSurfaceDark,
      // onBackground removed: use onSurface instead
      outline: AppColors.outlineOnDark,
    );
  }

  @override
  TextTheme get _textTheme {
    return AppTheme.uiTextTheme.apply(
      bodyColor: AppColors.white,
      displayColor: AppColors.white,
      decorationColor: AppColors.white,
    );
  }

  @override
  SnackBarThemeData get _snackBarTheme {
    return SnackBarThemeData(
      contentTextStyle: UITextStyle.bodyText1.copyWith(color: AppColors.black),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.sm),
      ),
      actionTextColor: AppColors.lightBlue.shade300,
      backgroundColor: AppColors.grey.shade300,
      elevation: 4,
      behavior: SnackBarBehavior.floating,
    );
  }

  @override
  TextButtonThemeData get _textButtonTheme {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        textStyle: _textTheme.labelLarge?.copyWith(
          fontWeight: AppFontWeight.light,
        ),
        foregroundColor: AppColors.white,
      ),
    );
  }

  @override
  Color get _backgroundColor => AppColors.grey.shade900;

  @override
  IconThemeData get _iconTheme {
    return const IconThemeData(color: AppColors.white);
  }

  @override
  DividerThemeData get _dividerTheme {
    return const DividerThemeData(
      color: AppColors.outlineOnDark,
      space: AppSpacing.xlg,
      thickness: AppSpacing.xxxs,
    );
  }

  @override
  InputDecorationTheme get _inputDecorationTheme {
    return InputDecorationTheme(
      suffixIconColor: AppColors.mediumEmphasisPrimary,
      prefixIconColor: AppColors.mediumEmphasisPrimary,
      hoverColor: AppColors.inputHoverDark,
      focusColor: AppColors.inputFocusedDark,
      fillColor: AppColors.inputEnabledDark,
      enabledBorder: _textFieldBorder,
      focusedBorder: _textFieldBorder,
      disabledBorder: _textFieldBorder,
      hintStyle: UITextStyle.bodyText1.copyWith(
        color: AppColors.mediumEmphasisPrimary,
      ),
      contentPadding: const EdgeInsets.all(AppSpacing.lg),
      border: const UnderlineInputBorder(),
      filled: true,
      isDense: true,
      errorStyle: UITextStyle.caption,
    );
  }

  @override
  ListTileThemeData get _listTileTheme {
    return ListTileThemeData(
      iconColor: AppColors.onSurfaceDark,
      textColor: AppColors.onSurfaceDark,
      contentPadding: EdgeInsets.all(AppSpacing.lg),
    );
  }

  @override
  AppBarTheme get _appBarTheme {
    return AppBarTheme(
      iconTheme: _iconTheme,
      titleTextStyle: _textTheme.titleLarge,
      elevation: 0,
      toolbarHeight: 64,
      backgroundColor: AppColors.transparent,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );
  }

  @override
  BottomNavigationBarThemeData get _bottomNavigationBarTheme {
    return BottomNavigationBarThemeData(
      backgroundColor: AppColors.surfaceDark,
      selectedItemColor: AppColors.white,
      unselectedItemColor: AppColors.white.withValues(alpha: 0.74),
    );
  }

  @override
  BottomSheetThemeData get _bottomSheetTheme =>
      BottomSheetThemeData(backgroundColor: AppColors.surfaceDark);

  @override
  ButtonThemeData get _buttonTheme => ButtonThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSpacing.sm),
    ),
  );

  @override
  ElevatedButtonThemeData get _elevatedButtonTheme => ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.sm),
      ),
    ),
  );

  @override
  ProgressIndicatorThemeData get _progressIndicatorTheme =>
      ProgressIndicatorThemeData(color: AppColors.white);

  @override
  SwitchThemeData get _switchTheme => SwitchThemeData(
    thumbColor: WidgetStateProperty.all(AppColors.white),
    trackColor: WidgetStateProperty.all(AppColors.outlineOnDark),
  );

  @override
  TabBarThemeData get _tabBarTheme => TabBarThemeData(
    indicator: ShapeDecoration(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.sm),
      ),
      color: AppColors.white,
    ),
  );

  @override
  ChipThemeData get _chipTheme => ChipThemeData(
    backgroundColor: AppColors.primaryContainerDark,
  );

  @override
  InputBorder get _textFieldBorder => const UnderlineInputBorder(
    borderSide: BorderSide(width: AppSpacing.xxxs, color: AppColors.darkAqua),
  );
}
