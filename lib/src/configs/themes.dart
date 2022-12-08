import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

final ThemeData fitaThemeLight = fitaTheme(ThemeData.light());

ThemeData fitaTheme(ThemeData themeBase) {
  final ThemeData base = themeBase;

  return base.copyWith(
    brightness: Brightness.light,
    colorScheme: _colorScheme(base.colorScheme),
    scaffoldBackgroundColor: AppColors.background,
    textTheme: _textTheme(base.textTheme),
    textSelectionTheme: _textSelectionTheme(base.textSelectionTheme),
  );
}

ColorScheme _colorScheme(ColorScheme base) => base.copyWith(
      primary: AppColors.primary,
      primaryContainer: AppColors.primaryVariant,
      secondary: AppColors.secondary,
      secondaryContainer: AppColors.secondaryVariant,
      background: AppColors.background,
      surface: AppColors.surface,
      onPrimary: AppColors.onPrimary,
      onSecondary: AppColors.onSecondary,
      onBackground: AppColors.onBackground,
      onSurface: AppColors.onSurface,
    );

TextTheme _textTheme(TextTheme base) {
  final baseStyle = GoogleFonts.montserratTextTheme(base);

  return baseStyle.copyWith(
    bodyText1: baseStyle.bodyText1?.copyWith(
      color: AppColors.black,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
    bodyText2: baseStyle.bodyText2?.copyWith(
      color: AppColors.black,
      fontSize: 14,
      fontWeight: FontWeight.bold,
    ),
    subtitle1: baseStyle.caption?.copyWith(
      color: AppColors.grey,
      fontSize: 12,
      fontWeight: FontWeight.bold,
    ),
    subtitle2: baseStyle.caption?.copyWith(
      color: AppColors.darkGrey,
      fontSize: 12,
      fontWeight: FontWeight.bold,
    ),
    caption: baseStyle.caption?.copyWith(
      color: AppColors.grey,
      fontSize: 10,
      fontWeight: FontWeight.bold,
    ),
  );
}

TextSelectionThemeData _textSelectionTheme(TextSelectionThemeData base) =>
    base.copyWith(
      cursorColor: AppColors.white,
      selectionColor: AppColors.white.withOpacity(.3),
      selectionHandleColor: AppColors.secondary.withOpacity(.75),
    );
