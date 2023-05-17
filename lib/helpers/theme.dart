import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ApplicationTheme {
  static ThemeData getTheme() {
    final TextTheme textTheme = ThemeData.light().textTheme.copyWith(
          headlineLarge: const TextStyle(
              fontWeight: FontWeight.w600, fontSize: 20, fontFamily: 'kadwa'),
          headlineMedium: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            fontFamily: 'georgia',
          ),
          headlineSmall: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 12,
            fontFamily: 'georgia',
          ),
          labelLarge: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            fontFamily: 'georgia',
          ),
          labelMedium: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            fontFamily: 'helvetica',
          ),
          labelSmall: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
            fontFamily: 'kadwa',
          ),
          displayMedium: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            fontFamily: 'kadwa',
          ),
          bodyLarge: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 16,
            fontFamily: 'georgia',
          ),
          bodyMedium: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 12,
              fontFamily: 'georgia',
              height: 1.5),
          titleLarge: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 24,
            fontFamily: 'georgia',
          ),
        );

    const ColorScheme colorScheme = ColorScheme(
      primary: Color(0xFFE75050),
      primaryContainer: Colors.white,
      secondary: Color(0xFF50657B),
      tertiary: Color(0xFF809AB2),
      tertiaryContainer: Color(0xFFD4DDE5),
      surface: Colors.white,
      background: Color(0xFFF0F0F0),
      error: Color(0xFFBB0520),
      onBackground: Color(0xFF303030),
      onSurface: Color(0xFF293b44),
      onError: Colors.white,
      onPrimary: Colors.white,
      onPrimaryContainer: Color(0xFF303030),
      onSecondary: Colors.white,
      onSecondaryContainer: Color(0xFF7F7F7F),
      onTertiary: Colors.white,
      onTertiaryContainer: Colors.white,
      brightness: Brightness.light,
    );

    final MaterialColor primarySwatch =
        createPrimarySwatch(colorScheme.primary);
    final Color? primaryColorDark = primarySwatch[800];
    final Color? primaryColorLight = primarySwatch[100];
    final Color? secondaryHeaderColor = primarySwatch[50];

    final Color effectiveAppBarColor = colorScheme.primary;
    final Brightness appBarBrightness =
        ThemeData.estimateBrightnessForColor(effectiveAppBarColor);

    final TargetPlatform platform = defaultTargetPlatform;

    final Typography typography = Typography.material2021(platform: platform);

    final Color selectedTabColor = colorScheme.primary;

    final Color unselectedTabColor = colorScheme.onSurface.withOpacity(0.6);

    double tooltipFontSize() {
      switch (platform) {
        case TargetPlatform.macOS:
        case TargetPlatform.linux:
        case TargetPlatform.windows:
          return 12;
        default:
          return 14;
      }
    }

    EdgeInsets tooltipPadding() {
      switch (platform) {
        case TargetPlatform.macOS:
        case TargetPlatform.linux:
        case TargetPlatform.windows:
          return const EdgeInsets.fromLTRB(8, 3, 8, 4);
        default:
          return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
      }
    }

    final Color dividerColor = colorScheme.onSurface.withOpacity(0.12);
    const Color disabledColor = Colors.black38;
    final Color hintColor = Colors.black.withOpacity(0.6);

    return ThemeData(
      primarySwatch: primarySwatch,
      textTheme: textTheme,
      fontFamily: 'Georgia',
      typography: typography,
      platform: platform,
      brightness: colorScheme.brightness,
      primaryColor: colorScheme.primary,
      canvasColor: colorScheme.background,
      scaffoldBackgroundColor: colorScheme.background,
      cardColor: colorScheme.surface,
      dividerColor: dividerColor,
      disabledColor: disabledColor,
      hintColor: hintColor,
      dialogBackgroundColor: colorScheme.surface,
      indicatorColor: selectedTabColor,
      applyElevationOverlayColor: false,
      colorScheme: colorScheme,
      primaryColorDark: primaryColorDark,
      primaryColorLight: primaryColorLight,
      secondaryHeaderColor: secondaryHeaderColor,
      appBarTheme: AppBarTheme(
        backgroundColor: effectiveAppBarColor,
        foregroundColor:
            appBarBrightness == Brightness.dark ? Colors.white : Colors.black,
        iconTheme: appBarBrightness == Brightness.dark
            ? const IconThemeData(color: Colors.white)
            : const IconThemeData(color: Colors.black87),
        actionsIconTheme: appBarBrightness == Brightness.dark
            ? const IconThemeData(color: Colors.white)
            : const IconThemeData(color: Colors.black87),
        elevation: 0.2,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: const Color(0x40000000),
          statusBarBrightness: appBarBrightness,
          statusBarIconBrightness: appBarBrightness == Brightness.dark
              ? Brightness.light
              : Brightness.dark,
          systemNavigationBarColor: const Color(0xFF000000),
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
      ),
      bottomAppBarTheme: BottomAppBarTheme(
        color: colorScheme.background,
        elevation: 0.2,
      ),
      textSelectionTheme: TextSelectionThemeData(
        selectionColor: colorScheme.primary.withOpacity(0.30),
        selectionHandleColor: primaryColorDark,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.primary.withOpacity(0.035),
      ),
      buttonTheme: const ButtonThemeData(
        colorScheme: colorScheme,
        textTheme: ButtonTextTheme.primary,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: EdgeInsets.symmetric(horizontal: 16),
      ),
      chipTheme: ChipThemeData.fromDefaults(
        secondaryColor: colorScheme.primary,
        brightness: colorScheme.brightness,
        labelStyle: textTheme.bodyLarge!,
      ),
      tabBarTheme: TabBarTheme(
        indicatorSize: TabBarIndicatorSize.tab,
        labelStyle: const TextTheme().bodyLarge,
        labelColor: selectedTabColor,
        unselectedLabelColor: unselectedTabColor,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedIconTheme: IconThemeData(
          color: colorScheme.primary,
        ),
        selectedItemColor: colorScheme.primary,
      ),
      tooltipTheme: TooltipThemeData(
        padding: tooltipPadding(),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        textStyle: textTheme.labelSmall!.copyWith(
          inherit: false,
          color: colorScheme.onPrimaryContainer,
          fontSize: tooltipFontSize(),
        ),
        decoration: BoxDecoration(
          color: colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: dividerColor),
        ),
      ),
    );
  }

  static MaterialColor createPrimarySwatch(Color? color) {
    color ??= const Color(0xff6200ee);
    const List<double> strengths = <double>[
      0.05,
      0.1,
      0.2,
      0.3,
      0.4,
      0.5,
      0.6,
      0.65,
      0.7,
      0.8,
      0.9
    ];
    final Map<int, Color> swatch = <int, Color>{};
    final int r = color.red;
    final int g = color.green;
    final int b = color.blue;
    for (final double strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }
}
